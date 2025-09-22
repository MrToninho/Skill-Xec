
function submitSearch() {
    const searchInput = document.getElementById('searchInput').value.trim();
    if (searchInput) {
        window.location.href = `search.aspx?q=${encodeURIComponent(searchInput)}`;
    }
}

document.addEventListener("DOMContentLoaded", function () {
    const bell = document.getElementById("notificationBell");
    const container = document.getElementById("notificationContainer");

    bell.addEventListener("click", () => {
        if (container.style.display === "none" || !container.style.display) {
            fetchNotifications();
            container.style.display = "block";
        } else {
            container.style.display = "none";
        }
    });

    function fetchNotifications() {
        fetch("NotificationHandler.aspx", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ action: "fetchNotifications" }),
        })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    container.innerHTML = "";
                    data.notifications.forEach(notification => {
                        const item = document.createElement("div");
                        item.className = "notification-item";
                        item.innerHTML = `
                            <p>${notification.message}</p>
                            <small>${notification.timestamp}</small>
                        `;
                        item.addEventListener("click", () => {
                            window.location.href = notification.link;
                        });
                        container.appendChild(item);
                    });
                } else {
                    container.innerHTML = "<p>Sem notificações.</p>";
                }
            })
            .catch(error => {
                console.error("Erro ao buscar notificações:", error);
                container.innerHTML = "<p>Erro ao carregar notificações.</p>";
            });
    }
});
