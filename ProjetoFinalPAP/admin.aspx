<%@ Page Language="C#" AutoEventWireup="true" CodeFile="admin.aspx.cs" Inherits="ProjetoFinalPAP.admin" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Skill Xec - Painel de Administração</title>
    <link rel="icon" type="image/png" href="imagens/skill-xec-logo.ico">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(to bottom, #ff416c, #833ab4);
            color: white;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }

        .custom-button {
            background: #833ab4;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            transition: background 0.3s ease;
            font-family: Arial, sans-serif;
        }

        .custom-button:hover {
            background: #ff416c;
        }

        .custom-button:disabled {
            background: #ccc;
            cursor: not-allowed;
        }

        .table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        .table th, .table td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: center;
        }

        .table th {
            background: #833ab4;
            color: white;
        }

        .admin-container {
            max-width: 1200px;
            margin: 20px auto;
            padding: 20px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
            color: black;
        }

        .admin-title {
            text-align: center;
            font-size: 2.5rem;
            margin-bottom: 30px;
            color: #ff416c;
        }

        .admin-menu {
            display: flex;
            justify-content: space-around;
            gap: 20px;
            flex-wrap: wrap;
        }

        .menu-item {
            width: 250px;
            background: #833ab4;
            color: white;
            padding: 20px;
            border-radius: 10px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .menu-item:hover {
            background: #ff416c;
            transform: scale(1.05);
            box-shadow: 0 6px 10px rgba(0, 0, 0, 0.2);
        }

        .menu-item i {
            font-size: 2.5rem;
            margin-bottom: 10px;
        }

        .hidden-section {
            display: none;
            margin-top: 20px;
            padding: 20px;
            background: #f9f9f9;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .auth-logo {
            width: 50px;
            margin-bottom: -40px;
            margin-left: -8px;
        }

        .hidden-section.active {
            display: block;
            animation: fadeIn 0.5s ease;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        button {
            padding: 10px 20px;
            background: #833ab4;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background 0.3s ease;
        }

        button:hover {
            background: #ff416c;
        }

        .search-bar {
            margin-bottom: 15px;
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 16px;
        }
    </style>
</head>
<body>
    <form id="adminForm" runat="server">
        <div class="admin-container">
            <a href="perfil.aspx">
                <img src="/imagens/back.png" alt="Logo" class="auth-logo">
            </a>
            <h1 class="admin-title">Painel de Administração</h1>
            <div class="admin-menu">
                <div class="menu-item" onclick="toggleSection('usersSection')">
                    <i class="fas fa-users"></i>
                    <p>Gestão de Utilizadores</p>
                </div>
                <div class="menu-item" onclick="toggleSection('videosSection')">
                    <i class="fas fa-video"></i>
                    <p>Gestão de Vídeos</p>
                </div>
                <div class="menu-item" onclick="toggleSection('reportsSection')">
                    <i class="fas fa-flag"></i>
                    <p>Denúncias</p>
                </div>
            </div>

            <!-- Gestão de Utilizadores -->
            <div id="usersSection" class="hidden-section">
                <h2>Gestão de Utilizadores</h2>
                <input 
                    type="text" 
                    id="userSearch" 
                    placeholder="Procurar utilizador por nome..." 
                    class="search-bar" 
                    onkeyup="filterUsers()"
                />
                <asp:GridView ID="GridViewUsers" runat="server" AutoGenerateColumns="False" CssClass="table" DataKeyNames="id" OnRowCommand="GridViewUsers_RowCommand">
                    <Columns>
                        <asp:BoundField DataField="id" HeaderText="ID" />
                        <asp:BoundField DataField="nome" HeaderText="Nome" />
                        <asp:BoundField DataField="email" HeaderText="Email" />
                        <asp:HyperLinkField 
                            DataNavigateUrlFields="id" 
                            DataTextField="username" 
                            DataNavigateUrlFormatString="canal.aspx?userId={0}" 
                            HeaderText="Nome de Utilizador" />
                        <asp:TemplateField HeaderText="Conta Ativa">
                            <ItemTemplate>
                                <%# Eval("ativo").ToString() == "True" ? "Sim" : "Não" %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Ações">
                        <ItemTemplate>
                            <asp:Button 
                            ID="BtnSuspend" 
                            runat="server" 
                            CommandName="Suspend" 
                            CommandArgument='<%# Eval("id") %>' 
                            Text='<%# Convert.ToBoolean(Eval("ativo")) ? "Suspender" : "Reativar" %>' 
                            CssClass="custom-button" 
                            OnClientClick="return confirm('Tem a certeza que deseja alterar o estado desta conta?');" />


                            <asp:Button 
                                ID="BtnRemove" 
                                runat="server" 
                                CommandName="Remove" 
                                CommandArgument='<%# Eval("id") %>' 
                                Text="Remover" 
                                CssClass="custom-button" 
                                OnClientClick="return confirm('Tem a certeza que deseja remover este utilizador? Esta ação não pode ser desfeita.');" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>

            <!-- Gestão de Vídeos -->
            <div id="videosSection" class="hidden-section">
                <h2>Gestão de Vídeos</h2>
                <asp:GridView ID="GridViewVideoUsers" runat="server" AutoGenerateColumns="False" CssClass="table" OnRowCommand="GridViewVideoUsers_RowCommand">
                    <Columns>
                        <asp:BoundField DataField="UserId" HeaderText="ID" />
                        <asp:BoundField DataField="Username" HeaderText="Nome de Utilizador" />
                        <asp:TemplateField HeaderText="Ações">
                            <ItemTemplate>
                                <asp:Button 
                                    ID="ViewVideosButton" 
                                    runat="server" 
                                    CommandName="ViewVideos" 
                                    CommandArgument='<%# Eval("UserId") %>' 
                                    Text="Ver Vídeos" 
                                    CssClass="custom-button" />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>

                <asp:Panel ID="PanelUserVideos" runat="server" Visible="false">
                    <h3>Vídeos do Utilizador: <asp:Label ID="SelectedUsernameLabel" runat="server"></asp:Label></h3>
                    <asp:GridView ID="GridViewUserVideos" runat="server" AllowPaging="True" PageSize="5" CssClass="table" OnPageIndexChanging="GridViewUserVideos_PageIndexChanging">
                        <Columns>
                            <asp:BoundField DataField="VideoId" HeaderText="ID" />
                            <asp:BoundField DataField="Title" HeaderText="Título" />
                            <asp:BoundField DataField="CategoryName" HeaderText="Categoria" />
                            <asp:BoundField DataField="UploadDate" HeaderText="Data de Envio" DataFormatString="{0:dd/MM/yyyy}" />
                            <asp:TemplateField HeaderText="Ações">
                                <ItemTemplate>
                                    <asp:Button ID="RemoveVideoButton" runat="server" CommandName="RemoveVideo" CommandArgument='<%# Eval("VideoId") %>' Text="Remover" CssClass="custom-button" />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </asp:Panel>
            </div>

            <!-- Gestão de Reports -->
            <div id="reportsSection" class="hidden-section">
                <h2>Denúncias</h2>
                <asp:GridView ID="GridViewReports" runat="server" AutoGenerateColumns="False" CssClass="table" DataKeyNames="ReportID" OnRowCommand="GridViewReports_RowCommand">
                <Columns>
                    <asp:BoundField DataField="ReportID" HeaderText="ID" />
                    <asp:BoundField DataField="ReporterName" HeaderText="Reportado por" />
                    <asp:BoundField DataField="TargetName" HeaderText="Utilizador Denunciado" />
                    <asp:BoundField DataField="reason" HeaderText="Razão" />
                    <asp:BoundField DataField="timestamp" HeaderText="Data" DataFormatString="{0:dd/MM/yyyy}" />
                    <asp:TemplateField HeaderText="Ações">
                        <ItemTemplate>
                            <asp:Button 
                                ID="BtnResolve" 
                                runat="server" 
                                CommandName="MarkResolved" 
                                CommandArgument='<%# Eval("ReportID") %>' 
                                Text="Resolver" 
                                CssClass="custom-button" 
                            />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
            </div>
        </div>
    </form>

    <script>
        function toggleSection(sectionId) {
            const section = document.getElementById(sectionId);
            const allSections = document.querySelectorAll('.hidden-section');

            allSections.forEach(sec => {
                if (sec.id !== sectionId) {
                    sec.classList.remove('active');
                }
            });

            section.classList.toggle('active');
        }

        function filterUsers() {
            const input = document.getElementById("userSearch");
            const filter = input.value.toLowerCase();
            const rows = document.querySelectorAll("#GridViewUsers tr");

            rows.forEach(row => {
                const nameCell = row.querySelector("td:nth-child(2)");
                if (nameCell) {
                    const text = nameCell.textContent || nameCell.innerText;
                    row.style.display = text.toLowerCase().includes(filter) ? "" : "none";
                }
            });
        }
    </script>
</body>
</html>
