<%@ Page Language="C#" AutoEventWireup="true" CodeFile="search.aspx.cs" Inherits="ProjetoFinalPAP.search" %>

<!DOCTYPE html>
<html lang="pt">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Skill Xec - Resultados da Pesquisa</title>
    <link rel="stylesheet" href="css/styles.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="icon" type="image/png" href="imagens/skill-xec-logo.ico">
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

        .categoriasSection {
    margin-top: 0; 
}


        .video-section h2 {
    margin: 0; 
    padding: 0;
    font-size: 24px;
    color: #333;
}

.video-grid {
    display: flex;
    flex-wrap: wrap;
    gap: 30px;
    padding: 0;
    justify-content: flex-start;
    margin-left:50px;
}


        .video-card {
            background: white;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            width: 220px;
            cursor: pointer;
            transition: transform 0.3s;
            margin-top:50px;
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

.titulo-container {
    margin-bottom: 20px; 
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
                <section class="video-section">
                <div class="titulo-container">
                    <h2>Resultados para '<%= Request.QueryString["q"] %>'</h2>
                </div>
                <div id="categoriasSection" runat="server" class="video-grid">
                </div>
            </section>
            </main>
        </div>
    </form>

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

        let currentPage = 1;
        let isLoading = false;

        window.addEventListener('scroll', async () => {
            if ((window.innerHeight + window.scrollY) >= document.body.offsetHeight - 500 && !isLoading) {
                isLoading = true;
                currentPage++;
                await loadMoreVideos();
                isLoading = false;
            }
        });

        async function loadMoreVideos() {
            const searchTerm = document.getElementById('searchInput').value.trim();
            const response = await fetch(`search.aspx?q=${encodeURIComponent(searchTerm)}&page=${currentPage}`);
            const html = await response.text();
            document.querySelector('.video-grid').insertAdjacentHTML('beforeend', html);
        }



    </script>
</body>
</html>
