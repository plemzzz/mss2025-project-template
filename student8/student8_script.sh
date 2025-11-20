#!/bin/bash

# 1. กำหนดชื่อไฟล์ต้นฉบับและไฟล์เป้าหมาย
TEMPLATE_FILE="/home/nitiroj/mss2025-project-template/student8/student8_template.html" # ไฟล์ template (ทำสำเนาจาก Student8.html)
TARGET_FILE="/home/nitiroj/mss2025-project-template/student8/student8.html"            # ไฟล์ที่จะถูกแก้ไขและแสดงผล

# ตรวจสอบว่ามีไฟล์ Template อยู่หรือไม่ (เพื่อให้สคริปต์สามารถรันซ้ำได้โดยไม่เสียหาย)
if [ ! -f "$TEMPLATE_FILE" ]; then
    echo "Creating template file from $TARGET_FILE..."
    cp "$TARGET_FILE" "$TEMPLATE_FILE"
fi

# 2. เก็บข้อมูลจาก Ubuntu Server

# เวลาที่ Run Script (Last updated at)
LAST_UPDATED_AT=$(date "+%Y-%m-%d %H:%M:%S %Z")

# CPU Usage (ดึงเปอร์เซ็นต์การใช้งาน CPU ทั้งหมด)
# ดึงค่า Idle (ตัวเลขที่ 4 ในฟิลด์ Cpu(s)) และใช้ awk คำนวณ (100 - $idle)
CPU_USAGE_RAW=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}' | cut -d',' -f1 | cut -d'.' -f1)
CPU_USAGE_STR="${CPU_USAGE_RAW}%"

# Memory Usage (Used/Total)
# free -h จะแสดงผลในรูปแบบที่อ่านง่าย, ดึงบรรทัดที่ 2 (Mem), ใช้ awk ดึง Used ($3) และ Total ($2)
MEMORY_DATA=$(free -h | grep Mem | awk '{print $3"/"$2}')
MEMORY_USAGE_STR="${MEMORY_DATA}"

# Storage Usage (Root partition - /)
# df -h แสดง Disk Usage, ดึงบรรทัดที่เป็น root mount point (/), ใช้ awk ดึง Use% ($5)
STORAGE_DATA=$(df -h | grep ' /$' | awk '{print $5}')
STORAGE_USAGE_STR="${STORAGE_DATA}"

# ข้อมูลอื่น ๆ (กำหนดเองอย่างน้อย 2 อย่าง)
# System Uptime (ระยะเวลาตั้งแต่เปิดเครื่อง)
SYSTEM_UPTIME=$(uptime -p)

# Kernel Version
KERNEL_VERSION=$(uname -r)

# 3. นำข้อมูลมาใส่ในหน้าเว็บ HTML ด้วย sed

# คัดลอกไฟล์ Template มาเป็นไฟล์เป้าหมายก่อนทำการแก้ไข
cp "$TEMPLATE_FILE" "$TARGET_FILE"

# ใช้ sed แทนที่ตัวแปรในไฟล์เป้าหมาย
# คำสั่ง sed -i.bak จะทำการแก้ไขไฟล์โดยตรงและสร้างไฟล์สำรอง (.bak) ไว้
# macOS/BSD sed อาจจะต้องใช้ sed -i '' แทน sed -i.bak
# ใน Linux (GNU sed): sed -i.bak 's/OLD_VALUE/NEW_VALUE/g' filename
# เนื่องจากข้อมูลบางส่วนมีเครื่องหมาย / จึงใช้เครื่องหมาย | แทนสำหรับ sed
sed -i.bak "s|@@LAST_UPDATED_AT@@|${LAST_UPDATED_AT}|g" "$TARGET_FILE"
sed -i.bak "s|@@CPU_USAGE@@|${CPU_USAGE_STR}|g" "$TARGET_FILE"
sed -i.bak "s|@@MEMORY_USAGE@@|${MEMORY_USAGE_STR}|g" "$TARGET_FILE"
sed -i.bak "s|@@STORAGE_USAGE@@|${STORAGE_USAGE_STR}|g" "$TARGET_FILE"
sed -i.bak "s|@@SYSTEM_UPTIME@@|${SYSTEM_UPTIME}|g" "$TARGET_FILE"
sed -i.bak "s|@@KERNEL_VERSION@@|${KERNEL_VERSION}|g" "$TARGET_FILE"

# ลบไฟล์สำรองที่ sed สร้างขึ้น
rm -f "$TARGET_FILE.bak"

echo "✅ Server status updated successfully in $TARGET_FILE at $LAST_UPDATED_AT"
