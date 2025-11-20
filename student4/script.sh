#!/bin/bash

# --- Configuration ---
# อัปเดต directory เป็น /home/warakon/mss2025-project-template/student4/
TEMPLATE_FILE="/home/warakon/mss2025-project-template/student4/student4.html"
OUTPUT_FILE="/home/warakon/mss2025-project-template/student4/index.html"

# --- Gathering Data ---
HOSTNAME=$(hostname)
IP_ADDR=$(hostname -I | awk '{print $1}')
SERVER_UPTIME=$(uptime -p | sed 's/up //')

# CPU Calculation
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')

# RAM Calculation
MEM_USAGE=$(free -m | awk 'NR==2{printf "%.2f", $3*100/$2 }')
MEM_TOTAL=$(free -h | awk 'NR==2{print $2}')

# Disk Calculation
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')
DISK_TOTAL=$(df -h / | awk 'NR==2 {print $2}')

LAST_UPDATE=$(date "+%Y-%m-%d %H:%M:%S")

# --- Processing HTML ---
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

    echo "----------------------------------------"
    echo " ✅ Dashboard Updated Successfully!"
    echo " 📂 Path: /home/warakon/mss2025-project-template/student4"
    echo " 🕒 Time: $LAST_UPDATE"
    echo " 📊 Stats -> CPU:$CPU_USAGE% | RAM:$MEM_USAGE% | HDD:$DISK_USAGE%"
    echo "----------------------------------------"
else
    echo " ❌ Error: Template file not found at $TEMPLATE_FILE"
    echo "    Please check if directory /home/warakon/mss2025-project-template/student4/ exists."
    exit 1
fi
