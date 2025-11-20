async function loadData() {
  const res = await fetch('data.json');
  const data = await res.json();

  // --- 1. ฟังก์ชันแปลงหน่วยความจำ (Helper Function) ---
  // สมมติว่า Input data เป็น KB (ตามที่เห็นในรูป 3 ล้านกว่า)
  const formatMem = (valVal) => {
    const val = parseFloat(valVal);
    // ถ้าค่ามากกว่า 1 ล้าน KB (ประมาณ 1 GB) ให้แปลงเป็น GB
    if (val > 1024 * 1024) { 
      return (val / (1024 * 1024)).toFixed(2) + ' GB';
    } 
    // ถ้าไม่ถึง ให้แปลงเป็น MB
    else {
      return (val / 1024).toFixed(0) + ' MB';
    }
  };
  
  // หมายเหตุ: ถ้า data ของคุณส่งมาเป็น MB อยู่แล้ว ให้แก้สูตรด้านบนเป็น:
  // if (val > 1024) return (val/1024).toFixed(2) + ' GB'; else return val + ' MB';

  // --- 2. แก้ไข System Info (ใส่ <span> ครอบค่า เพื่อให้ CSS Grid ทำงาน) ---
  document.getElementById('infoBox').innerHTML = `
    <h2>System Info</h2>
    <p><strong>OS:</strong> <span>${data.os}</span></p>
    <p><strong>Kernel:</strong> <span>${data.kernel}</span></p>
    <p><strong>CPU:</strong> <span>${data.cpu}</span></p>
    <p><strong>GPU:</strong> <span>${data.gpu}</span></p>
    <p><strong>Uptime:</strong> <span>${data.upTime}</span></p>
    <p><strong>Date:</strong> <span>${data.day} ${data.month} ${data.year}</span></p>
    <p><strong>Time:</strong> <span>${data.time}</span></p>
  `;

  // --- 3. System Usage Calculation ---
  
  // CPU
  const cpuVal = parseFloat(data.cpu_used) * 100;
  document.getElementById('cpuBar').style.width = cpuVal + '%';
  document.getElementById('cpuText').innerText = `${cpuVal.toFixed(1)}%`;

  // Memory (ใช้ฟังก์ชัน formatMem ที่สร้างไว้)
  const memPer = parseFloat(data.mem_used_per);
  const memUsedRaw = data.mem_used_mb; // ค่าดิบ (คาดว่าเป็น KB)
  const memTotalRaw = data.mem_total_mb; // ค่าดิบ (คาดว่าเป็น KB)
  
  document.getElementById('memBar').style.width = memPer + '%';
  document.getElementById('memText').innerText = `${formatMem(memUsedRaw)} / ${formatMem(memTotalRaw)} (${memPer.toFixed(1)}%)`;

  // Disk (แปลง GB ตามปกติ)
  const diskUsed = parseFloat(data.disk_used_gb);
  const diskTotal = parseFloat(data.disk_total_gb);
  const diskPer = (diskUsed / diskTotal) * 100;

  document.getElementById('diskBar').style.width = diskPer + '%';
  document.getElementById('diskText').innerText = `${diskUsed} GB / ${diskTotal} GB (${diskPer.toFixed(1)}%)`;

  // --- Process Table ---
  const psTable = document.querySelector('#psTable tbody');
  psTable.innerHTML = '';
  data.ps.forEach(p => {
    const row = document.createElement('tr');
    row.innerHTML = `
      <td>${p.pid}</td>
      <td>${p.ppid}</td>
      <td>${p.cpu}</td>
      <td>${p.mem}</td>
      <td>${p.command}</td>`;
    psTable.appendChild(row);
  });
}

loadData();
