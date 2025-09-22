<%@ Page Language="C#" AutoEventWireup="true" CodeFile="index.aspx.cs" Inherits="ProjetoFinalPAP.index" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Skill Xec</title>
    <link rel="icon" type="image/png" href="imagens/skill-xec-logo.ico">
    <link rel="stylesheet" href="css/styles.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <script src="js/scripts.js"></script>
    <style>
       .video-grid {
    display: flex; 
    flex-wrap: wrap; 
    gap: 20px; 
    padding: 20px; 
    justify-content: flex-start; 
}

.video-card {
    background: white;
    border-radius: 5px;
    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
    overflow: hidden;
    width: 100%; 
    max-width: 306px;
    cursor: pointer;
    transition: transform 0.3s;
    display:inline-grid;
}

.notification-container {
    position: absolute;
    top: 50px;
    right: 20px;
    width: 300px;
    background: white;
    border: 1px solid #ccc;
    border-radius: 5px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    display: none;
    z-index: 1000;
}

.notification-item {
    padding: 10px;
    border-bottom: 1px solid #eee;
    cursor: pointer;
}

.notification-item:hover {
    background-color: #f9f9f9;
}

.notification-item:last-child {
    border-bottom: none;
}


.video-card:hover {
    transform: scale(1.03);
}

.video-thumbnail img {
    width: 100%;
    height: auto;
}

.video-info {
    padding: 10px;
    text-align: left; 
}

.video-title {
    font-size: 16px;
    font-weight: bold;
    margin-bottom: 5px;
    text-align: left; 
}

.video-info p {
    font-size: 14px;
    color: #555;
    margin: 5px 0;
    text-align: left; 
}


        .video-details {
            font-size: 14px;
            color: #555;
        }

        .video-section {
            margin-bottom: 40px;
        }

        .video-section h2 {
            font-size: 24px;
            margin-bottom: 20px;
            text-align: left ;
            color: #333;
            margin-left:10px;
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
        <header class="header">
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
                <button id="btnUpload" runat="server" onserverclick="btnUpload_Click" class="upload-btn">
                    <i class="fas fa-upload"></i> Carregar Vídeo
                </button>
                <i class="fas fa-bell notification-icon"></i>
                <div class="user-avatar">
                    <a href="<%= Session["UserID"] == null ? "login.aspx" : "perfil.aspx" %>">
                        <img src="imagens/user-avatar.png" alt="User Avatar">
                    </a>
                </div>
            </div>
        </header>
        <div class="container">
            <aside class="sidebar">
                <h2>Menu</h2>
                <ul>
                    <li><a href="index.aspx"><i class="fas fa-home"></i> Home</a></li>
                    <li><a href="subscricoes.aspx"><i class="fas fa-user-friends"></i> Subscrições</a></li>
                    <li><a href="canal.aspx"><i class="fas fa-user"></i> O Meu Canal</a></li>
                    <li><a href="historico.aspx"><i class="fas fa-history"></i> Histórico</a></li>
                    <li><a href="favoritos.aspx"><i class="fa-solid fa-heart"></i> Favoritos</a></li>
                    <li><a href="mailto:skillxecsuporte@gmail.com"><i class="fas fa-envelope"></i> Ajuda e Suporte</a></li>
                </ul>
            </aside>
            <main class="main-content">
                <section id="popularesSection" runat="server" class="video-section">
                    <!-- Vídeos populares -->
                </section>
                <section id="recomendacoesSection" runat="server" class="video-section">
                    <!-- Recomendações -->
                </section>
            </main>
        </div>
    </form>
</body>
    <script>
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
 
</html>
