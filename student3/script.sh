#!/bin/bash

JSON_FILE="/home/midfield/gitHub/mss2025-project-template/student3/data.json"

#Date
DATA=$(date | cut -d' ' -f3,2,4,7)
read -r month day time year <<< "$DATA"
echo "LastUpdate: $year/ $month/ $day/ $time pm."


#Memused
MemUsedPer=$(sar -r 1 1 | grep -E '^Average' | awk '{print $5}')
MemUsed=$(sar -r 1 1 | grep -E '^Average' | awk '{print $4}')
MemTotal=$(sar -r 1 1 | grep -E '^Average' | awk '{print $3}')

echo "Memory Used: $MemUsedPer%"
echo "($MemUsed/$MemTotal)"

#Cpuused
CpuLeft=$(sar -u 1 1 | grep -E '^Average' | awk '{print $8}')
CpuUsed=$(echo "100.00 - $CpuLeft" | bc)

echo "CPU Used: $CpuUsed%"


#Disk
DiskUsed=$(df -h | grep '^/' | cut -d' ' -f11)
DiskTotal=$( df -h | grep '^/' | cut -d' ' -f9)

echo "Storage Usage $DiskUsed/$DiskTotal"

cat > $JSON_FILE << EOF
{
  "month": "$month",
  "day": "$day",
  "time": "$time",
  "year": "$year",
  "cpu_used": "$(echo "$CpuUsed" | tr -d '\n\r')",
  "mem_used_per": "$MemUsedPer",
  "mem_used_mb": "$MemUsed",
  "mem_total_mb": "$MemTotal",
  "disk_used_gb": "$DiskUsed",
  "disk_total_gb": "$DiskTotal"
}
EOF

