#!/bin/bash

TEMPLATE_FILE="/home/kritsakorn/github/mss2025-project-template/student1/template.html"
FILE="/home/kritsakorn/github/mss2025-project-template/student1/student1.html"

HOSTNAME=$(hostname)
current_time=$(TZ=Asia/Bangkok date)
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')

# 3. Memory
mem_total=$(free -m | awk '/Mem:/ { print $2 }')
mem_used=$(free -m | awk '/Mem:/ { print $3 }')
# คำนวณ % แบบไม่มีทศนิยม เพื่อใช้ในกราฟ
mem_percent=$(awk "BEGIN {printf \"%.0f\", ($mem_used/$mem_total)*100}")
# ข้อความที่จะโชว์ (Used/Total)
mem_txt="${mem_used}MB / ${mem_total}MB"

STORAGE_USAGE=$(df -h / | awk '/\// {print $5}')
uptime_info=$(uptime -p)
kernel_info=$(uname -r)

cp "$TEMPLATE_FILE" "$FILE"

# CPU
sed -i "s|{{CPU_VAL}}|$CPU_USAGE|g" "$FILE"

# Memory
sed -i "s|{{MEM_VAL}}|$mem_percent|g" "$FILE"
sed -i "s|{{MEM_TXT}}|$mem_txt|g" "$FILE"

# Disk
sed -i "s|{{DISK_VAL}}|$STORAGE_USAGE|g" "$FILE"

# Others
sed -i "s|{{UPTIME}}|$uptime_info|g" "$FILE"
sed -i "s|{{KERNEL}}|$kernel_info|g" "$FILE"
sed -i "s|{{LAST_UPDATED}}|$current_time|g" "$FILE"
