#!/bin/bash

# --- การตั้งค่า Path (แก้ไขแล้ว) ---
BASE_DIR="/home/chisanupong/mss2025-project-template/student6"
TEMPLATE_FILE="$BASE_DIR/student6.html"
OUTPUT_FILE="$BASE_DIR/index.html"

# --- 1. ดึงข้อมูลระบบ ---
HOSTNAME=$(hostname)
IP_ADDR=$(hostname -I | awk '{print $1}')
SERVER_UPTIME=$(uptime -p | sed 's/up //')

# CPU (รวม User + System)
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')

# RAM
MEM_USAGE=$(free -m | awk 'NR==2{printf "%.2f", $3*100/$2 }')
MEM_TOTAL=$(free -h | awk 'NR==2{print $2}')

# DISK (Root Partition)
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')
DISK_TOTAL=$(df -h / | awk 'NR==2 {print $2}')

# เวลา
LAST_UPDATE=$(date "+%Y-%m-%d %H:%M:%S")

# --- 2. ตรวจสอบไฟล์ Template ---
if [ -f "$TEMPLATE_FILE" ]; then
    
    # --- 3. แทนที่ข้อมูล ---
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

    echo "✅ [Student6] Updated index.html successfully!"
    echo "   Time: $LAST_UPDATE"
    echo "   Path: $OUTPUT_FILE"
else
    echo "❌ Error: ไม่พบไฟล์ Template ที่ $TEMPLATE_FILE"
    echo "   กรุณาสร้างไฟล์ student6.html ในโฟลเดอร์ student6 ก่อน"
fi
