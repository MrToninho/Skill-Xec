<%@ Page Language="C#" AutoEventWireup="true" CodeFile="upload.aspx.cs" Inherits="ProjetoFinalPAP.upload" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Skill Xec - Upload</title>
    <link rel="icon" type="image/png" href="imagens/skill-xec-logo.ico">
    <link rel="stylesheet" href="css/styles.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
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

        .subscription-title {
            margin-top: 30px;
            font-size: 14px;
            font-weight: bold;
            text-transform: uppercase;
            color: rgba(255, 255, 255, 0.7);
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
            position: fixed;
            top: 0;
            z-index: 1000;
            display: flex;
            align-items: center;
            justify-content: space-between;
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

        .search-bar {
            width: 70%;
            padding: 8px;
            font-size: 1rem;
            border: 1px solid #ddd;
            border-radius: 5px;
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
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
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

        .upload-form {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 600px;
            margin: 0 auto;
            margin-left:435px;
        }

        .upload-form h2 {
            font-size: 24px;
            font-weight: bold;
            color: #333;
            margin-bottom: 20px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            font-size: 14px;
            color: #555;
            display: block;
            margin-bottom: 5px;
        }

        .form-group .input,
        .form-group .file-input,
        .form-group .dropdown {
            width: 100%;
            padding: 10px;
            font-size: 14px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }

        .submit-btn {
            background: #007bff;
            color: white;
            border: none;
            padding: 10px 15px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
        }

        .submit-btn:hover {
            background: #0056b3;
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
    width: 1340px;
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
                <section class="upload-form">
                    <h2>Carregar Vídeo</h2>
                    <div class="form-group">
                        <label for="videoFile">Selecionar Vídeo</label>
                        <asp:FileUpload ID="videoFile" runat="server" CssClass="file-input" accept="video/*" />
                    </div>
                    <div class="form-group">
                        <label for="videoTitle">Título do Vídeo</label>
                        <asp:TextBox ID="videoTitle" runat="server" CssClass="input" placeholder="Título do vídeo" />
                         <p style="font-size: 12px; color: red; margin-top: 5px;">
                            * Não se esqueça de incluir o nome do jogo no título para que os utilizadores saibam do que se trata.
                        </p>
                    </div>
                    <div class="form-group">
                        <label for="videoDescription">Descrição</label>
                        <asp:TextBox ID="videoDescription" runat="server" CssClass="input" TextMode="MultiLine" placeholder="Descrição do vídeo"></asp:TextBox>
                        <p style="font-size: 12px; color: red; margin-top: 5px;">
                            * Inclua mais detalhes sobre o jogo aqui, se achar necessário.
                        </p>
                    </div>
                    <div class="form-group">
                        <label for="videoThumbnail">Thumbnail</label>
                        <asp:FileUpload ID="videoThumbnail" runat="server" CssClass="file-input" />
                    </div>
                    <div class="form-group">
                        <label for="videoCategory">Categoria</label>
                        <asp:DropDownList ID="videoCategory" runat="server" CssClass="dropdown">
                        </asp:DropDownList>
                    </div>
                    <div class="form-group">
                        <label for="visibility">Visibilidade</label>
                        <asp:DropDownList ID="visibility" runat="server" CssClass="dropdown">
                            <asp:ListItem Text="Público" Value="public" />
                            <asp:ListItem Text="Privado" Value="private" />
                        </asp:DropDownList>
                    </div>
                    <asp:Button ID="btnSubmit" runat="server" CssClass="submit-btn" Text="Carregar Vídeo" OnClick="btnSubmit_Click" />
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
</script>
</body>
</html>