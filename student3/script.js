function updateDashboard() {
    fetch("data.json?cacheBust=" + Date.now())   // ป้องกัน cache
        .then(res => res.json())
        .then(data => {
            
            // Date & Time
            document.getElementById("datetime").innerText =
                `${data.month} ${data.day}, ${data.year} — ${data.time}`;

            // System Info
            document.getElementById("os").innerText = data.os;
            document.getElementById("kernel").innerText = data.kernel;
            document.getElementById("cpu").innerText = data.cpu;
            document.getElementById("gpu").innerText = data.gpu;
            document.getElementById("uptime").innerText = data.upTime;

            // CPU
            let cpuUsed = parseFloat(data.cpu_used);
            document.getElementById("cpu_used_text").innerText = cpuUsed;
            document.getElementById("cpu_bar").style.width = cpuUsed + "%";

            // Memory
            let memUsed = parseFloat(data.mem_used_per);
            document.getElementById("mem_used_text").innerText = memUsed;
            document.getElementById("mem_bar").style.width = memUsed + "%";

            // Disk
            let used = parseFloat(data.disk_used_gb.replace("G", ""));
            let total = parseFloat(data.disk_total_gb.replace("G", ""));
            let diskPercent = (used / total) * 100;

            document.getElementById("disk_used_text").innerText =
                `${data.disk_used_gb} / ${data.disk_total_gb} (${diskPercent.toFixed(2)}%)`;

            document.getElementById("disk_bar").style.width =
                diskPercent.toFixed(2) + "%";
        })
        .catch(err => console.error("Error loading JSON:", err));
}

updateDashboard();

setInterval(updateDashboard, 1000);

