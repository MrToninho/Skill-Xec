<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="subscricoes.aspx.cs" Inherits="ProjetoFinalPAP.subscricoes" %>

<!DOCTYPE html>
<html lang="pt">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Skill Xec - Subscrições</title>
    <link rel="stylesheet" href="css/styles.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="icon" type="image/png" href="imagens/skill-xec-logo.ico">
    <script src="js/scripts.js"></script>
    <style>
        @font-face {
            font-family: 'Modulus Pro';
            src: url('../fonts/modulus-pro-semi-bold.otf') format('opentype');
            font-weight: 600;
            font-style: normal;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            display: flex;
            min-height: 100vh;
        }

        .container {
            display: flex;
            width: 100%;
            height: 100vh;
        }

        .sidebar {
            width: 250px;
            background: linear-gradient(to bottom, #ff416c, #833ab4);
            color: white;
            padding: 20px;
            display: flex;
            flex-direction: column;
            height: 100vh;
        }

        .main-content {
            flex: 1;
            padding: 20px;
            display: flex;
            flex-direction: column;
            margin-top: 80px;
        }

        .header {
            width: 100%;
            background-color: white;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            padding: 10px 40px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            position: fixed;
            top: 0;
            z-index: 1000;
        }

        .upload-btn {
            padding: 10px 15px;
            background: #007bff;
            color: white;
            border: none;
            border-radius: 55px;
            cursor: pointer;
            font-size: 14px;
            text-decoration: none;
        }

        .subscription-grid {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            padding: 20px;
        }

        .subscription-card {
            background: white;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            padding: 20px;
            text-align: center;
            width: 220px; 
            display: flex;
            flex-direction: column;
            align-items: center;
            text-decoration: none; 
        }

        .subscription-card h3,
        .subscription-card p {
            text-decoration: none; 
        }

        .subscription-avatar img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

            .subscription-avatar {
        border: 3px solid #007bff;
        border-radius: 50%;
        overflow: hidden;
        width: 100px;
        height: 100px;
        margin-bottom: 15px;
    }
            a.subscription-card {
            text-decoration: none;
            color: inherit; 
        }

        .subscription-card:hover {
            transform: scale(1.02);
            transition: transform 0.3s ease;
        }

        .unsubscribe-btn {
            background: #dc3545;
            color: white;
            padding: 10px 15px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            margin-top: 10px;
        }

        .unsubscribe-btn:hover {
            background: #b71d2a;
        }

                .search-bar-container {
    display: flex;
    align-items: center;
    justify-content: center;
}

.search-form {
    display: flex;
    align-items: center;
}

.search-bar {
    width: 1180px;
    padding: 10px;
    border: 1px solid #ccc;
    border-radius: 4px 0 0 4px;
    font-size: 14px;
}

.search-btn {
    padding: 10px;
    background-color: #007bff;
    color: white;
    border: none;
    border-radius: 0 4px 4px 0;
    cursor: pointer;
}

.search-btn i {
    font-size: 16px;
}

.search-btn:hover {
    background-color: #0056b3;
}
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="header">
            <div class="header-left">
                <img src="imagens/skill-xec-logo.png" alt="Logo" class="logo-icon">
                <span class="logo-title">Skill Xec</span>
            </div>
            <div class="search-bar-container">
    <form onsubmit="submitSearch(); return false;" class="search-form">
        <input 
            type="text" 
            class="search-bar" 
            id="searchInput" 
            placeholder="Procurar..." 
            value="<%= Request.QueryString["q"] %>">
        <button 
            type="button" 
            class="search-btn" 
            onclick="submitSearch()">
            <i class="fas fa-search"></i>
        </button>
    </form>
</div>
            <div class="header-right">
                <a href="upload.aspx" class="upload-btn"><i class="fas fa-upload"></i> Carregar Vídeo</a>
                <i class="fas fa-bell notification-icon"></i>
                <div class="user-avatar">
                    <a href="perfil.aspx">
                        <img src="imagens/user-avatar.png" alt="User Avatar">
                    </a>
                </div>
            </div>
        </div>
        <div class="container">
            <aside class="sidebar">
                <h2>Menu</h2>
                <ul>
                    <li><a href="index.aspx"><i class="fas fa-home"></i> Home</a></li>
                    <li><a href="subscricoes.aspx" class="active"><i class="fas fa-user-friends"></i> Subscrições</a></li>
                    <li><a href="canal.aspx"><i class="fas fa-user"></i> O Meu Canal</a></li>
                    <li><a href="historico.aspx"><i class="fas fa-history"></i> Histórico</a></li>
                    <li><a href="favoritos.aspx"><i class="fa-solid fa-heart"></i> Favoritos</a></li>
                                        <li><a href="mailto:skillxecsuporte@gmail.com"><i class="fas fa-envelope"></i> Ajuda e Suporte</a></li>

                </ul>
            </aside>
            <main class="main-content">
                    <h1 style="font-family: Arial, sans-serif; font-size: 24px; color: #333; margin-bottom: 20px;">Subscrições</h1>
                <div id="subscricoesSection" runat="server" class="subscription-grid"></div>
            </main>
        </div>
    </form>
    <script>
        document.addEventListener("click", function (e) {
            if (e.target.classList.contains("unsubscribe-btn")) {
                e.preventDefault(); 
                const subscriptionId = e.target.dataset.subscriptionId;

                if (confirm("Tem certeza de que deseja cancelar a subscrição?")) {
                    fetch("subscricoes.aspx/CancelarSubscricao", {
                        method: "POST",
                        headers: {
                            "Content-Type": "application/json"
                        },
                        body: JSON.stringify({ id: subscriptionId })
                    })
                        .then(response => response.json())
                        .then(data => {
                            if (data.d === "Sucesso") {
                                const card = e.target.closest(".subscription-card");
                                card.remove();
                                alert("Subscrição cancelada com sucesso!");
                            } else {
                                alert("Erro ao cancelar subscrição.");
                            }
                        })
                        .catch(err => console.error(err));
                }
            }
        });
            document.addEventListener('keydown', function (event) {
        const searchInput = document.getElementById('searchInput');
            if (event.key === 'Enter' && document.activeElement === searchInput) {
                event.preventDefault();
            submitSearch();
        }
    });
            function submitSearch() {
        const searchInput = document.getElementById('searchInput').value.trim();
            if (searchInput) {
                window.location.href = `search.aspx?q=${encodeURIComponent(searchInput)}`;
        }
    }
</script>
</body>
</html>
