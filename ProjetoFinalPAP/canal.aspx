<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="canal.aspx.cs" Inherits="ProjetoFinalPAP.canal" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Skill Xec - Canal</title>
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
            z-index: 1000;
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
            margin-left: -270px;
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

        .channel-banner {
            width: 100%; 
            height: 375px; 
            position: fixed; 
            top: 0; 
            left: 0; 
            background-color: #f4f4f4; 
            z-index: 1; 
            overflow: hidden; 
        }

        .channel-banner .banner-img {
            width: 100%;
            height: 100%;
            object-fit: cover; 
            display: block;
            pointer-events: none;
        }

        .change-banner-btn {
            position: absolute;
            top: 75px;
            right: 30px;
            background-color: rgba(0, 0, 0, 0.6);
            color: white;
            border: none;
            border-radius: 5px;
            padding: 10px 15px;
            font-size: 14px;
            cursor: pointer;
            z-index: 10;
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .change-banner-btn:hover {
            background-color: rgba(0, 0, 0, 0.8);
        }

        .channel-profile {
            position: absolute;
            top: 336px;
            left: 275px; 
            z-index: 10; 
            display: flex;
            align-items: center;
        }

        .channel-profile img {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            border: 5px solid white;
            object-fit: cover;
        }

        .channel-name {
            font-size: 24px;
            font-weight: bold;
            margin-left: 15px;
            margin-top: 36px;
        }

        .nav-tabs {
            all: unset; 
            position: fixed; 
            top: 375px; 
            left: 0;
            width: 100%; 
            background-color: white; 
            z-index: 5; 
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1); 
            display: flex; 
            justify-content: center; 
            padding: 10px 0; 
            border-bottom: 2px solid #eaeaea; 
        }

        .nav-tabs button {
            background: none; 
            border: none; 
            font-size: 16px; 
            font-weight: bold; 
            padding: 10px 20px; 
            cursor: pointer; 
            color: #333; 
            transition: color 0.3s, border-bottom 0.3s; 
            margin-left: 120px;
        }

        .nav-tabs button:hover {
            color: #ff516b; 
        }

        .nav-tabs .active {
            color: #ff516b; 
            border-bottom: 2px solid #ff516b; 
        }

        .channel-page .nav-tabs {
            margin-top: 10px; 
        }

        .video-grid {
            margin-top: 360px; 
            display: grid;
            grid-template-columns: repeat(5, 1fr);
            gap: 20px;
            padding: 20px;
            justify-items: center;
        }

        .video-card {
            background: white;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            width: 355px;
            cursor: pointer;
            transition: transform 0.3s;
        }

        .video-card:hover {
            transform: scale(1.03);
        }

        .video-card img {
            width: 100%;
        }

        .video-card h4 {
            font-size: 16px;
            margin: 10px;
        }

        .video-card p {
            font-size: 14px;
            color: #555;
            margin: 10px;
        }

        .social-links {
            position: absolute;
            right: 25px;
            top: 44%;
            transform: translateY(-50%);
            display: flex;
            gap: 15px;
            z-index: 1000;
        }

        .social-links a {
            color: #555;
            font-size: 20px;
            text-decoration: none;
            transition: color 0.3s ease;
        }

        .social-links a:hover {
            color: #007bff;
        }

        .video-actions {
            margin-top: 10px;
        }

        .edit-btn {
            display: inline-block;
            background: #007bff;
            color: white;
            padding: 8px 12px;
            font-size: 14px;
            border-radius: 4px;
            text-decoration: none;
            transition: background 0.3s ease;
        }

        .edit-btn:hover {
            background: #0056b3;
        }

        .video-thumbnail {
            width: 100%;
            height: auto;
            border-radius: 10px;
            cursor: pointer;
            transition: transform 0.2s ease-in-out;
        }

        .video-thumbnail:hover {
            transform: scale(1.05);
        }
        .subscribe-btn {
            padding: 10px 20px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 55px;
            cursor: pointer;
            font-size: 16px;
            margin-left: 20px;
            margin-top:35px;
        }

        .subscribe-btn:hover {
            background-color: #0056b3;
        }

        .channel-subscribers {
            font-size: 14px;
            font-weight: bold;
            color: #555;
            margin-top: 5px;
            margin-left: 15px;
        }
                .subscriber-count {
            font-size: 20px;
            font-weight: bold;
            margin-top: 45px;
            margin-bottom: 5px;
            text-align: center;
            margin-left:20px;
        }
                .unsubscribe-btn {
            padding: 10px 20px;
            background-color: #dc3545; 
            color: white;
            border: none;
            border-radius: 55px;
            cursor: pointer;
            font-size: 16px;
            margin-left: 20px;
            margin-top: 35px;
            transition: background-color 0.3s ease;
        }

        .unsubscribe-btn:hover {
            background-color: #c82333; 
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

.report-button {
    position: absolute; 
    right: 160px; 
    top: -22%; 
    transform: translateY(-50%); 
    padding: 10px 20px;
    background-color: #bbb927; 
    color: white;
    border: none;
    border-radius: 55px;
    cursor: pointer;
    font-size: 16px;
    transition: background-color 0.3s ease;
    z-index: 10; 
    margin-top:17px;
    margin-right:-60px;
    width:133px;
}


    </style>
</head>
<body>
   <form id="form1" runat="server">
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
                <button id="btnUpload" runat="server" onserverclick="btnUpload_Click" class="upload-btn">
                    <i class="fas fa-upload"></i> Carregar Vídeo
                </button>
                    <i class="fas fa-bell notification-icon"></i>
                    <div class="user-avatar">
                        <a href="perfil.aspx">
                            <img src="imagens/user-avatar.png" alt="User Avatar">
                        </a>
                    </div>
                </div>
            </div>
            <div class="channel-banner">
            <div class="channel-banner">
                <img id="bannerImage" runat="server" class="banner-img" src="imagens/banners/banner-placeholder.png" />
                <asp:FileUpload ID="fileBanner" runat="server" CssClass="file-upload" Style="display:none;" accept="image/*" />
                <asp:Button ID="btnUploadBanner" runat="server" Text="Salvar" CssClass="upload-btn" Style="display:none;" OnClick="btnUploadBanner_Click" />
                <button id="btnChangeBanner" runat="server" class="change-banner-btn" onclick="triggerFileUpload(); return false;">
                    <i class="fas fa-edit"></i> Mudar Banner
                </button>
            </div>
            </div>
            <div class="nav-tabs">
                <button class="active" onclick="showTab('videos')">Videos</button>
            </div>
            <div class="channel-profile">
                <img id="imgProfile" runat="server" class="channel-profile-img" />
                <div id="channelName" runat="server" class="channel-name"></div>
                <div class="subscriber-count">
                    <asp:Literal ID="subscriberCountDiv" runat="server" />
                </div>
                <asp:Button ID="btnSubscribe" runat="server" CssClass="subscribe-btn" OnClick="Subscribe_Click" />
                  
            </div>
          
            <div id="videosContainer" runat="server" class="video-grid"></div>

            <asp:Repeater ID="RepeaterVideos" runat="server">
                <ItemTemplate>
                    <div class="video-card" onclick="window.location.href='watch.aspx?v=<%# Eval("id") %>'">
                        <img src='<%# Eval("thumbnail") %>' alt='<%# Eval("titulo") %>' class="video-thumbnail" />
                        <h4><%# Eval("titulo") %></h4>
                        <p><%# Eval("visualizacoes", "{0} views") %> | <%# Eval("data_upload", "{0:dd MMMM yyyy}") %></p>
                        <p><strong>Categoria:</strong> <%# Eval("categoria_nome") %></p>
                        <div class="video-actions">
                            <a href="editar-video.aspx?id=<%# Eval("id") %>" class="edit-btn">Editar</a>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
            </div>
            <div class="social-links">
                <div class="report-buttons">
                    <% if (!(bool)ViewState["IsUserOwnChannel"]) { %>
                <button class="report-button" onclick="openReportModal('<%= Request.QueryString["channelId"] %>', 'user')">    <i class="fas fa-flag"></i> Denunciar</button> <% } %>
                </div>
            <a href="#"><i class="fab fa-facebook"></i></a>
            <a href="#"><i class="fab fa-twitter"></i></a>
            <a href="#"><i class="fab fa-instagram"></i></a>
        </div>
        </main>
    </div>
   </form>
   <script>
        function triggerFileUpload() {
            document.getElementById('<%= fileBanner.ClientID %>').click(); 
            document.getElementById('<%= fileBanner.ClientID %>').onchange = function () {
                document.getElementById('<%= btnUploadBanner.ClientID %>').click();
           };
       }

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

       function getQueryParameter(param) {
           const urlParams = new URLSearchParams(window.location.search);
           return urlParams.get(param);
       }

       function openReportModal(targetId) {
           const isLoggedIn = <%= Session["UserID"] != null ? "true" : "false" %>;

           if (!isLoggedIn) {
               alert("Inicie a sessão para denunciar conteúdo ofensivo ou enganoso.");
               return;
           }

           if (!targetId) {
               targetId = getQueryParameter("userId"); 
               if (!targetId) {
                   alert("Não foi possível identificar o utilizador a ser reportado.");
                   return;
               }
           }

           const reason = prompt("Por favor, diga a razão para denunciar este utilizador:");
           if (reason) {
               sendReport("user", targetId, reason.trim()); 
           }
       }

       function sendReport(type, id, reason) {
           fetch('reportHandler.aspx', {
               method: 'POST',
               headers: { 'Content-Type': 'application/json' },
               body: JSON.stringify({ type, id, reason })
           })
               .then(response => response.json())
               .then(data => {
                   if (data.success) {
                       alert("Obrigado pela sua ajuda! A denúncia foi enviada com sucesso.");
                   } else {
                       alert(`Ocorreu um erro ao enviar o report: ${data.error || "Erro desconhecido"}`);
                   }
               })
               .catch(err => console.error("Erro ao reportar:", err));
       }



   </script>
</body>
</html>