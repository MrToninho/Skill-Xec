<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="favoritos.aspx.cs" Inherits="ProjetoFinalPAP.favoritos" %>

<!DOCTYPE html>
<html lang="pt">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Skill Xec - Favoritos</title>
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

        .sidebar h2 {
            font-size: 24px;
            margin-bottom: 20px;
            font-family: 'Modulus Pro', sans-serif;
        }

        .sidebar ul {
            list-style: none;
            padding: 0;
        }

        .sidebar ul li {
            margin: 15px 0;
        }

        .sidebar ul li a {
            color: white;
            text-decoration: none;
            font-size: 16px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .main-content {
            flex: 1;
            padding: 20px;
            display: flex;
            flex-direction: column;
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
            margin-left: 0px;
        }

        .header-left {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .logo-icon {
            width: 40px;
            height: 40px;
            object-fit: contain;
        }

        .logo-title {
            font-family: 'Modulus Pro', sans-serif;
            font-weight: 600;
            font-size: 24px;
            color: #333;
        }

        .header-right {
            display: flex;
            align-items: center;
            gap: 20px;
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

        .notification-icon {
            font-size: 18px;
            color: #555;
            cursor: pointer;
        }

        .user-avatar img {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: block;
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

        
        .video-grid {
            display: flex; 
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); 
            gap: 20px; 
            padding: 20px; 
            justify-content: center; 
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
            text-align: center; 
        }

        .video-title {
            font-size: 16px;
            font-weight: bold;
            margin-bottom: 5px;
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
                <h1 style="font-family: Arial, sans-serif; font-size: 24px; color: #333; margin-bottom: 20px;">Favoritos</h1>
            <div id="videoGrid" class="video-grid"></div>
        </main>
      </div>
    </form>

    <script>
        document.addEventListener("DOMContentLoaded", function () {
            fetch("favoritos.aspx", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ action: "fetchFavorites" }),
            })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        const grid = document.getElementById("videoGrid");
                        data.favorites.forEach(video => {
                            const card = document.createElement("div");
                            card.className = "video-card";
                            card.innerHTML = `
                        <a href="watch.aspx?id=${video.id}">
                            <img src="${video.thumbnail}" alt="Thumbnail">
                        </a>
                        <h3>${video.title}</h3>
                        <p>Criador: ${video.creator}</p>
                        <p>Categoria: ${video.category}</p>
                        <p>${video.views} visualizações</p>

                    `;
                            grid.appendChild(card);
                        });
                    } else {
                        console.error(data.message);
                    }
                })
                .catch(error => console.error("Erro ao carregar favoritos:", error));
        });


        function submitSearch() {
            const searchInput = document.getElementById("searchInput").value.trim();
            if (searchInput) {
                window.location.href = `search.aspx?q=${encodeURIComponent(searchInput)}`;
            }
        }
    </script>
</body>
</html>
