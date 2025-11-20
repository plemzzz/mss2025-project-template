// script.js

const REFRESH_RATE = 1000; // อัตราการอัปเดต: 1000 มิลลิวินาที = 1 วินาที

function updateMetrics() {
    // เพิ่ม Cache Buster (?t=) เพื่อให้เบราว์เซอร์ไม่ใช้ข้อมูลเก่า
    fetch('data.json?t=' + new Date().getTime())
        .then(response => {
            if (!response.ok) {
                throw new Error('Metrics file not found or server error');
            }
            return response.json();
        })
        .then(data => {
            // 1. แสดงค่า Timestamp
            const fullTimestamp = `${data.year}/${data.month}/${data.day} ${data.time}`;
            document.getElementById('timestamp').textContent = fullTimestamp;

            // 2. CPU Utilization
            // ***ตัวอย่างการใช้ innerHTML เพื่อใส่ Hyperlink***
            const cpuValue = parseFloat(data.cpu_used).toFixed(2);
            document.getElementById('cpu_usage').innerHTML = '<a href="/cpu-details.html">' + cpuValue + '</a>'; // ใช้ innerHTML

            // 3. Memory Usage
            document.getElementById('mem_usage_per').textContent = parseFloat(data.mem_used_per).toFixed(2);
            document.getElementById('mem_used_mb').textContent = data.mem_used_mb;
            document.getElementById('mem_total_mb').textContent = data.mem_total_mb;

            // 4. Disk Usage
            document.getElementById('disk_usage_gb').textContent = data.disk_used_gb;
            document.getElementById('disk_total_gb').textContent = data.disk_total_gb;
            
            // คำนวณ %Disk Used จากค่าที่ดึงมา
            const usedValue = parseFloat(data.disk_used_gb.replace(/[GM]/, ''));
            const totalValue = parseFloat(data.disk_total_gb.replace(/[GM]/, ''));
            
            if (totalValue > 0) {
                const diskPer = (usedValue / totalValue) * 100;
                document.getElementById('disk_used_per').textContent = `(${diskPer.toFixed(1)}% Used)`;
            } else {
                document.getElementById('disk_used_per').textContent = `(N/A)`;
            }
        })
        .catch(error => {
            console.error("การดึงข้อมูลล้มเหลว:", error);
            document.getElementById('timestamp').textContent = 'ERROR: ไม่สามารถอ่าน metrics.json ได้';
        });
}

// เรียกฟังก์ชันเมื่อโหลดหน้าเสร็จ
updateMetrics(); 

// ตั้งเวลาให้เรียกฟังก์ชัน updateMetrics ซ้ำทุกๆ 1 วินาที
setInterval(updateMetrics, REFRESH_RATE);
