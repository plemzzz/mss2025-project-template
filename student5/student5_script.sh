#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
HTML_FILE="/home/muftee/project/mss2025-project-template/web/students.html"

# Metrics Data Collection

CPU_IDLE=$(top -bn1 | grep "Cpu(s)" | sed 's/.*, *\([0-9.]*\)%* id.*/\1/' | awk '{print int($1)}')
CPU_USAGE=$((100 - CPU_IDLE))
CPU_VALUE="${CPU_USAGE}%"

MEM_TOTAL=$(free -m | awk 'NR==2{print $2}')
MEM_USED=$(free -m | awk 'NR==2{print $3}')
MEM_PERCENT=$(awk "BEGIN {printf \"%.1f\", ${MEM_USED}*100/${MEM_TOTAL}}")
MEM_VALUE="${MEM_PERCENT}% (${MEM_USED}MB/${MEM_TOTAL}MB)"

STORAGE_PERCENT=$(df -h / | awk 'NR==2{print $5}')
STORAGE_VALUE="${STORAGE_PERCENT}"

UPTIME_VALUE=$(uptime -p | sed 's/up //')

PROCS_VALUE=$(ps -e | wc -l)

TIME_VALUE=$(date +"%Y-%m-%d %H:%M:%S")

# Replace Function 
replace_placeholder() {
    sed -i "s|<span id=\"$1\">.*</span>|<span id=\"$1\">$2</span>|g" "$HTML_FILE"
}

# Execute Replacement

replace_placeholder "cpu_usage" "$CPU_VALUE"
replace_placeholder "mem_usage" "$MEM_VALUE"
replace_placeholder "storage_usage" "$STORAGE_VALUE"

replace_placeholder "uptime" "$UPTIME_VALUE"
replace_placeholder "processes" "$PROCS_VALUE"

replace_placeholder "last_updated" "$TIME_VALUE"

echo "Metrics updated in $HTML_FILE successfully on $TIME_VALUE"
