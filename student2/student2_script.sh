#!/bin/bash

TEMPLATE_FILE="/home/plemzzz/mss2025-project-template/student2/student2.html"
OUTPUT_FILE="/home/plemzzz/mss2025-project-template/student2/index.html"

HOSTNAME=$(hostname)
IP_ADDR=$(hostname -I | awk '{print $1}')
SERVER_UPTIME=$(uptime -p | sed 's/up //')

CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')

MEM_USAGE=$(free -m | awk 'NR==2{printf "%.2f", $3*100/$2 }')
MEM_TOTAL=$(free -h | awk 'NR==2{print $2}')  # ดึงค่า Total (เช่น 16Gi)

DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')
DISK_TOTAL=$(df -h / | awk 'NR==2 {print $2}') # ดึงค่า Size (เช่น 50G)

LAST_UPDATE=$(date "+%Y-%m-%d %H:%M:%S")


if [ -f "$TEMPLATE_FILE" ]; then
    
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

    echo " Dashboard Updated Successfully!"
    echo "   Stats: CPU:$CPU_USAGE% | Mem:$MEM_USAGE% | Disk:$DISK_USAGE%"
    echo "   Output: $OUTPUT_FILE"
else
    echo " Error: Template file not found at $TEMPLATE_FILE"
fi
