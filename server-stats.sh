#!/bin/bash

# ==============================================================================
# Script Name: server-stats.sh
# Description: Analyzes basic Linux server performance stats and system metrics.
# ==============================================================================

# Colors for clean terminal output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_header() {
    echo -e "\n${BLUE}==================== $1 ====================${NC}"
}

# 1. System Information & Stretch Goals
print_header "SYSTEM INFORMATION"
if [ -f /etc/os-release ]; then
    . /etc/os-release
    echo "OS Version:          $PRETTY_NAME"
fi
echo "Uptime:              $(uptime -p 2>/dev/null || uptime)"
echo "Load Average:        $(awk '{print $1, $2, $3}' /proc/loadavg)"
echo "Logged-in Users:     $(who | wc -l)"

# Failed login attempts (Requires root/sudo privileges for logs like /var/log/btmp)
if command -v lastb &> /dev/null; then
    failed_logins=$(sudo lastb 2>/dev/null | wc -l)
    echo "Failed Login Count:  $failed_logins (Run with sudo for exact count)"
fi

# 2. Total CPU Usage
print_header "CPU USAGE"
cpu_idle=$(top -bn1 | grep -i "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print $1}')
if [ -z "$cpu_idle" ]; then
    # Fallback for newer top output formats
    cpu_idle=$(top -bn1 | grep -i "%Cpu" | awk '{print $8}')
fi
cpu_usage=$(awk "BEGIN {print 100 - $cpu_idle}")
echo "Total CPU Usage:     ${cpu_usage}%"

# 3. Total Memory Usage
print_header "MEMORY USAGE"
free -m | awk 'NR==2 {
    total=$2;
    used=$3;
    free=$4;
    printf "Total Memory:    %d MB\n", total;
    printf "Used Memory:     %d MB (%.2f%%)\n", used, (used/total)*100;
    printf "Free Memory:     %d MB (%.2f%%)\n", free, (free/total)*100;
}'

# 4. Total Disk Usage
print_header "DISK USAGE"
df -h --total 2>/dev/null | grep "total" | awk '{
    total=$2;
    used=$3;
    free=$4;
    percent=$5;
    printf "Total Disk:      %s\n", total;
    printf "Used Disk:       %s (%s)\n", used, percent;
    printf "Free Disk:       %s\n", free;
}' || {
    # Fallback if df --total is not supported by the system
    df -h / | awk 'NR==2 {
        printf "Total Disk (/):  %s\n", $2;
        printf "Used Disk (/):   %s (%s)\n", $3, $5;
        printf "Free Disk (/):   %s\n", $4;
    }'
}

# 5. Top 5 Processes by CPU Usage
print_header "TOP 5 PROCESSES BY CPU USAGE"
ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head -n 6

# 6. Top 5 Processes by Memory Usage
print_header "TOP 5 PROCESSES BY MEMORY USAGE"
ps -eo pid,comm,%cpu,%mem --sort=-%mem | head -n 6

echo -e "\n${GREEN}Server performance analysis completed successfully!${NC}"
