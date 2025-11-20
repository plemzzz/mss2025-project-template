async function loadData() {
  const res = await fetch('data.json');
  const data = await res.json();

  document.getElementById('infoBox').innerHTML = `
    <h2>System Info</h2>
    <p><strong>OS:</strong> ${data.os}</p>
    <p><strong>Kernel:</strong> ${data.kernel}</p>
    <p><strong>CPU:</strong> ${data.cpu}</p>
    <p><strong>GPU:</strong> ${data.gpu}</p>
    <p><strong>Uptime:</strong> ${data.upTime}</p>
    <p><strong>Date:</strong> ${data.day} ${data.month} ${data.year}</p>
    <p><strong>Time:</strong> ${data.time}</p>
  `;

  document.getElementById('cpuBar').style.width = (parseFloat(data.cpu_used) * 100) + '%';
  document.getElementById('memBar').style.width = parseFloat(data.mem_used_per) + '%';
  document.getElementById('diskBar').style.width = (parseFloat(data.disk_used_gb) / parseFloat(data.disk_total_gb)) * 100 + '%';

  const psTable = document.querySelector('#psTable tbody');
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

