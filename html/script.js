window.addEventListener('message', function(event) {
    let data = event.data;
    if (data.action === "openMenu") {
        document.getElementById('container').classList.remove('hidden');
        document.getElementById('menu-title').innerText = data.title;
        
        let container = document.getElementById('menu-content');
        container.innerHTML = '';

        data.items.forEach((item) => {
            let el = document.createElement('div');
            el.className = 'menu-item';
            el.innerHTML = `
                <div>
                    <strong>${item.label}</strong><br>
                    <small>Price: $${item.price} ${item.minRank !== undefined ? '| Min Rank: ' + item.minRank : ''}</small>
                </div>
                <button onclick="selectAction('${data.type}', '${data.job}', '${item.name}')">Requisition</button>
            `;
            container.appendChild(el);
        });
    }
});

document.getElementById('close-btn').addEventListener('click', () => {
    document.getElementById('container').classList.add('hidden');
    fetch(`https://${GetParentResourceName()}/closeUI`, { method: 'POST' });
});

function selectAction(type, job, itemName) {
    document.getElementById('container').classList.add('hidden');
    fetch(`https://${GetParentResourceName()}/selectItem`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ type: type, job: job, item: itemName })
    });
}
