<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="watch.aspx.cs" Inherits="ProjetoFinalPAP.watch" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Skill Xec - Histórico</title>
    <link rel="stylesheet" href="css/styles.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="icon" type="image/png" href="imagens/skill-xec-logo.ico">
    <script src="js/scripts.js"></script>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

       body {
        font-family: Arial, sans-serif;
        background-color: #f4f4f4;
        display: flex;
        flex-direction: column;
        min-height: 100vh;
        margin: 0;
        padding: 0;
        overflow: auto;
    }

        .container {
            display: flex;
            width: 100%;
            height: 100%;
        }

        .sidebar {
            width: 250px;
            background: linear-gradient(to bottom, #ff416c, #833ab4);
            color: white;
            padding: 20px;
            display: flex;
            flex-direction: column;
            height: 100vh;
            overflow-y: auto;
            position: sticky;
            top: 0;
        }

        .sidebar h2 {
            font-size: 24px;
            margin-bottom: 20px;
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
        overflow-y: auto;
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


        .video-container {
        width: 100%; 
        display: flex;
        justify-content: center;
        margin-top: 20px;
    }


         .video-player {
        width: 90%;
        max-width: 1200px; 
        aspect-ratio: 16/9;
        background: #000;
    }


        .video-details {
    width: 145%; 
    max-width: 1630px; 
    margin-left: auto; 
    margin-right: auto; 
    padding: 15px 20px; 
    background-color: #ffffff; 
    border-radius: 8px; 
    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1); 
    margin-top:20px;
}


        .video-stats {
            font-size: 14px;
            color: #555;
        }

        .channel-info {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .channel-image {
            text-align: center;
        }

        .channel-image img {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            object-fit: cover;
            margin-top: 20px;
        }

        .subscriber-count {
            margin-top: 8px;
            font-size: 14px;
            color: #555;
        }

        .reaction-buttons {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 10px;
            margin-top: -46px;
            margin-left:1324px;
        }

        .reaction-buttons button {
            display: flex;
            align-items: center;
            gap: 5px;
            padding: 5px 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
            background-color: #f9f9f9;
            cursor: pointer;
            font-size: 14px;
            transition: background-color 0.3s ease, color 0.3s ease;
        }


        .reaction-buttons button:hover {
            background-color: #e9e9e9;
        }

        .reaction-buttons button.active {
            background-color: #007bff;
            color: white;
            border-color: #007bff;
        }

           .comment-section {
            margin-top: 30px;
        }

        .comment-input {
            width: 100%;
            margin-bottom: 10px;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 35px;
            font-size: 14px;
        }

        .comment {
            margin-bottom: 15px;
        }

        .comment-header {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-top: 10px;
        }

        .comment-header img {
            width: 40px;
            height: 40px;
            border-radius: 50%;
        }

         .delete-comment-btn {
            background-color: #dc3545;
            color: white;
            border: none;
            padding: 8px 12px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            margin-top: 10px;
            transition: background-color 0.3s ease;
        }

        .delete-comment-btn:hover {
            background-color: #c82333;
        }


        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 5px;
            margin-top: 20px;
        }

        .pagination-btn {
            padding: 8px 12px;
            background-color: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 4px;
            font-size: 14px;
        }

        .pagination-btn:hover {
            background-color: #0056b3;
        }

        .pagination-btn.disabled {
            background-color: #ccc;
            cursor: not-allowed;
            pointer-events: none;
        }

        .pagination-btn.active {
            background-color: #0056b3;
            font-weight: bold;
            pointer-events: none;
        }

        .video-meta {
            margin-top: 20px;
            background-color: #fff;
            padding: 15px;
        }

        .video-meta p {
            margin: 5px 0;
            font-size: 14px;
            color: #333;
        }

        .expandable {
            resize: horizontal; 
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

.favorite-btn {
    background-color: #d01523;
    color: white;
    padding: 10px 15px;
    border: none;
    border-radius: 5px;
    font-size: 14px;
    transition: background-color 0.3s ease, transform 0.2s ease;
    margin-left: 1325px;
    cursor: pointer;
}

.favorite-btn.active {
    background-color: #28a745; 
    box-shadow: 0 0 10px #28a745; 
    transform: scale(1.05);
}

.favorite-btn:hover {
    background-color: #f77f84;
    transform: scale(1.1);
}

.report-button {
    position: absolute; 
    right: 118px; 
    top: 882px; 
    transform: translateY(-50%); 
    padding: 10px 20px;
    background-color: #bbb927; 
    color: white;
    border: none;
    border-radius: 5px;
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

                <div class="video-container expandable">
                    <video id="videoPlayer" class="video-player" controls runat="server"></video>
                </div>
                <div class="video-details">
                    <h1 id="videoTitle" runat="server"></h1>
                    <p id="videoStats" runat="server" class="video-stats"></p>
                   <div class="reaction-buttons">
                        <button id="likeButton" onclick="reactToVideo('like', event)">
                            👍 Gosto <span id="likeCount">0</span>
                        </button>
                        <button id="dislikeButton" onclick="reactToVideo('dislike', event)">
                            👎 Não Gosto <span id="dislikeCount">0</span>
                        </button>
                    </div>
                      <div class="favorite-btn-container">
                        <button id="favoriteButton" class="favorite-btn" onclick="toggleFavorite(event)">
                            ❤️ Favorito
                        </button>
                          <div class="report-buttons">
                    <button class="report-button" onclick="openReportModal('<%= Request.QueryString["channelId"] %>', 'user')">    <i class="fas fa-flag"></i>Denunciar</button>
                    </div>
                    </div>
                    <div class="channel-info">
                        <div class="channel-image">
                            <a href="canal.aspx?userId=<%= Session["VideoOwnerID"] %>">
                                <img id="profileImage" runat="server" alt="User Avatar" />
                            </a>
                             <p class="subscriber-count"><%= Session["TotalSubscribers"] %> Subscritores</p>
                        </div>
                        <div class="channel-details">
                            <span id="channelName" runat="server"></span>
                        </div>
                    </div>
                    <div class="video-meta">
                        <p><strong>Categoria:</strong> <span id="category" runat="server"></span></p>
                        <p><strong>Descrição:</strong> <span id="description" runat="server"></span></p>
                    </div>
                </div>

                <div class="comment-section">
                    <h3>Comentários</h3>
                    <asp:TextBox ID="commentTextBox" runat="server" CssClass="comment-input" placeholder="Escreva um comentário..." autocomplete="off"></asp:TextBox>
                    <button id="btnPostComment" runat="server" onserverclick="PostComment_Click" class="upload-btn">Comentar</button>
                    <div id="commentsSection" runat="server"></div>
                </div>
            </main>
        </div>
    </form>

    <script>
        document.addEventListener("click", function (e) {
            if (e.target.classList.contains("delete-comment-btn")) {
                e.preventDefault();

                const commentId = e.target.getAttribute("data-comment-id");

                if (confirm("Tem a certeza que quer remover este comentário?")) {
                    fetch("watch.aspx", {
                        method: "POST",
                        headers: { "Content-Type": "application/json" },
                        body: JSON.stringify({
                            action: "delete",
                            comment_id: commentId
                        }),
                    })
                        .then((response) => {
                            if (!response.ok) {
                                console.error("Erro na resposta do servidor.");
                                return { success: false, message: "Erro no servidor" };
                            }
                            return response.json();
                        })
                        .then((data) => {
                            if (data.success) {
                                const commentElement = document.getElementById(`comment-${commentId}`);
                                if (commentElement) {
                                    commentElement.remove();
                                }
                            } else {
                                console.error("Erro ao remover comentário:", data.message);
                                window.location.reload();
                            }
                        })
                        .catch((error) => {
                            console.error("Erro:", error);
                            window.location.reload();
                        });
                }
            }
        });

        function reactToVideo(reactionType, e) {
            if (e) e.preventDefault();

            const videoId = "<%= Request.QueryString["id"] %>";

            fetch("watch.aspx", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ action: "react", video_id: videoId, reaction_type: reactionType }),
            })
                .then((response) => response.json())
                .then((data) => {
                    if (data.success) {
                        document.getElementById("likeCount").innerText = data.likes;
                        document.getElementById("dislikeCount").innerText = data.dislikes;

                        updateReactionButtons(reactionType);
                    } else {
                        alert("Gostou/Não Gostou do vídeo? Inicie a sessão para dar a sua opinião.");
                    }
                })
                .catch((error) => {
                    console.error("Erro ao enviar requisição:", error);
                });
        }


        function updateReactionButtons(reactionType) {
            const likeButton = document.getElementById("likeButton");
            const dislikeButton = document.getElementById("dislikeButton");

            likeButton.classList.remove("active");
            dislikeButton.classList.remove("active");

            if (reactionType === "like") {
                likeButton.classList.add("active");
            } else if (reactionType === "dislike") {
                dislikeButton.classList.add("active");
            }
        }


        window.addEventListener("load", function () {
            const videoId = "<%= Request.QueryString["id"] %>";

           fetch("watch.aspx", {
               method: "POST",
               headers: { "Content-Type": "application/json" },
               body: JSON.stringify({ action: "getReactions", video_id: videoId }),
           })
               .then((response) => response.json())
               .then((data) => {
                   if (data.success) {
                       document.getElementById("likeCount").innerText = data.likes;
                       document.getElementById("dislikeCount").innerText = data.dislikes;

                       if (data.userReaction) {
                           updateReactionButtons(data.userReaction);
                       }
                   }
               })
               .catch((error) => console.error("Erro ao carregar reações:", error));
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

        function toggleFavorite(event) {
            if (event) event.preventDefault();

            const videoId = "<%= Request.QueryString["id"] %>";
            const favoriteButton = document.getElementById("favoriteButton");

            fetch("watch.aspx", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ action: "toggleFavorite", video_id: videoId }),
            })
                .then((response) => response.json())
                .then((data) => {
                    if (data.success) {
                        favoriteButton.classList.toggle("active");
                    } else {
                        alert("Inicie a sessão para adicionar aos favoritos.");
                    }
                })
                .catch((error) => {
                    console.error("Erro ao alternar favorito:", error);
                });
        }

        window.addEventListener("load", function () {
            const videoId = "<%= Request.QueryString["id"] %>";
            const favoriteButton = document.getElementById("favoriteButton");

            fetch("watch.aspx", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ action: "checkFavorite", video_id: videoId }),
            })
                .then((response) => response.json())
                .then((data) => {
                    if (data.success) {
                        if (data.isFavorite) {
                            favoriteButton.classList.add("active");
                        } else {
                            favoriteButton.classList.remove("active");
                        }
                    }
                })
                .catch((error) => console.error("Erro ao verificar favorito:", error));
        });

        function openReportModal(targetId) {
            const isLoggedIn = <%= Session["UserID"] != null ? "true" : "false" %>;

            if (!isLoggedIn) {
                alert("Inicie a sessão para denunciar conteúdo ofensivo ou enganoso.");
                return;
            }

            const reason = prompt("Por favor, diga a razão para denunciar este utilizador:");
            if (reason) {
                sendReport(targetId, reason);
            }
        }

        function sendReport(targetId, reason) {
            fetch('reportHandler.aspx', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ id: targetId, reason: reason })
            })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        alert("Obrigado pela sua ajuda! A denúncia foi enviada com sucesso.");
                    } else {
                        alert("Erro ao enviar denúncia: " + data.error);
                    }
                })
                .catch(err => console.error("Erro ao denunciar:", err));
        }


</script>
</body>
</html>
