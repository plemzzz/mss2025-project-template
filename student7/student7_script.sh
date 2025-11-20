#!/bin/bash

# ==========================================
# ส่วนตั้งค่าการเชื่อมต่อ (CONFIGURATION)
# ==========================================
# 1. ระบุโฟลเดอร์หลัก
BASE_DIR="/home/sirapob/project/mss2025-project-template/student7"

# 2. ระบุชื่อไฟล์ต้นฉบับ (Template) และไฟล์ปลายทาง (Output)
TEMPLATE_FILE="$BASE_DIR/student7.html"
OUTPUT_FILE="$BASE_DIR/index.html"

# ==========================================
# ส่วนดึงข้อมูลระบบ (SYSTEM METRICS)
# ==========================================
echo "⚙️  กำลังดึงข้อมูลระบบ..."
HOSTNAME=$(hostname)
IP_ADDR=$(hostname -I | awk '{print $1}')
SERVER_UPTIME=$(uptime -p | sed 's/up //')
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print int($2 + $4 + 0.5)}')
MEM_USAGE=$(free -m | awk 'NR==2{printf "%.0f", $3*100/$2 }')
MEM_TOTAL=$(free -h | awk 'NR==2{print $2}')
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')
DISK_TOTAL=$(df -h / | awk 'NR==2 {print $2}')
LAST_UPDATE=$(date "+%Y-%m-%d %H:%M:%S")

# ==========================================
# ส่วนประมวลผล (PROCESS)
# ==========================================
# ตรวจสอบว่าไฟล์ Template มีอยู่จริงหรือไม่
if [ -f "$TEMPLATE_FILE" ]; then
    echo "🔄 พบไฟล์ Template! กำลังแทนที่ข้อมูล..."
    
    # แทนที่ตัวแปรใน HTML (${VAR}) ด้วยค่าจริง
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

    echo "✅ เสร็จสมบูรณ์!"
    echo "📂 ไฟล์ถูกสร้างที่: $OUTPUT_FILE"
else
    echo "❌ ข้อผิดพลาด: ไม่พบไฟล์ $TEMPLATE_FILE"
    echo "   กรุณาตรวจสอบว่ามีไฟล์ student7.html อยู่ในโฟลเดอร์ $BASE_DIR หรือไม่"
fi
