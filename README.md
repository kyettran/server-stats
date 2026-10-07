Project URL: https://github.com/kyettran/server-stats

# Server Performance Stats Analyzer (server-stats.sh)

A lightweight, robust Bash script designed to analyze core Linux server performance metrics quickly and efficiently.

## Features
- **System Information:** OS version, uptime, load average, logged-in users, and failed login attempts.
- **CPU Usage:** Total CPU utilization calculated via real-time sampling.
- **Memory Usage:** Total, used, and free RAM in megabytes along with percentage metrics.
- **Disk Usage:** Total, used, and free disk space with utilization percentages.
- **Top Processes:** Identifies the top 5 resource-heavy processes by CPU and Memory usage.

## Prerequisites
- Any modern Linux distribution (Ubuntu, Debian, CentOS, RHEL, etc.)
- Bash shell
- Standard core utilities (`top`, `free`, `df`, `ps`, `awk`)

## Installation & Usage

1. **Clone the repository:**
   ```bash
   git clone [https://github.com/kyettran/server-stats.git](https://github.com/kyettran/server-stats.git)
   cd server-stats
