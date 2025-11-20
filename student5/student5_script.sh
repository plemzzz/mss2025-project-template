#!/bin/bash

# Configuration
TEMPLATE_FILE="/home/muftee/project/mss2025-project-template/student5/student5.html"
OUTPUT_FILE="/home/muftee/project/mss2025-project-template/student5/index.html"

# 1. Gather System Metrics
# Hostname and IP
HOSTNAME=$(hostname)
IP_ADDR=$(hostname -I | awk '{print $1}')
SERVER_UPTIME=$(uptime -p | sed 's/up //')

# CPU Usage (total of user and system time)
# Note: This gives a combined load average which might exceed 100% on multicore systems,
# but is standard for simple top output usage.
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')

# Memory Usage (Used % and Total)
MEM_USED_KB=$(free -k | awk 'NR==2{print $3}')
MEM_TOTAL_KB=$(free -k | awk 'NR==2{print $2}')
MEM_USAGE=$(printf "%.2f" "$((MEM_USED_KB * 100 / MEM_TOTAL_KB))")
MEM_TOTAL=$(free -h | awk 'NR==2{print $2}') 

# Disk Usage (Used % and Total)
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')
DISK_TOTAL=$(df -h / | awk 'NR==2 {print $2}') 

# Last Update Timestamp
LAST_UPDATE=$(date "+%Y-%m-%d %H:%M:%S")

# 2. Update HTML Template
if [ -f "$TEMPLATE_FILE" ]; then
    # Use sed to replace all placeholders in the template with actual values
    # NOTE: The variable names in the script match the placeholders in the HTML templates
    sed -e "s|\${HOSTNAME}|$HOSTNAME|g" \
        -e "s|\${IP_ADDR}|$IP_ADDR|g" \
        -e "s|\${SERVER_UPTIME}|$SERVER_UPTIME|g" \
        -e "s|\${CPU_USAGE}|$CPU_USAGE|g" \
        -e "s|\${MEM_USAGE}|$MEM_USAGE|g" \
        -e "s|\${MEM_TOTAL}|$MEM_TOTAL|g" \
        -e "s|\${DISK_USAGE}|$DISK_USAGE|g" \
        -e "s|\${DISK_TOTAL}|$DISK_TOTAL|g" \
        -e "s|\${LAST_UPDATE}|$LAST_UPDATE|g" \
        "$TEMPLATE_FILE" > "$OUTPUT_FILE"

    echo "✅ Dashboard Updated Successfully!"
    echo "   Stats: CPU:$CPU_USAGE% | Mem:$MEM_USAGE% | Disk:$DISK_USAGE%"
    echo "   Output: $OUTPUT_FILE"
else
    echo "❌ Error: Template file not found at $TEMPLATE_FILE"
fi
