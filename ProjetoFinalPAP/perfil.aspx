<%@ Page Language="C#" AutoEventWireup="true" CodeFile="perfil.aspx.cs" Inherits="ProjetoFinalPAP.perfil" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Skill Xec - Perfil</title>
    <link rel="icon" type="image/png" href="imagens/skill-xec-logo.ico">
    <link rel="stylesheet" href="/css/styles.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <style>
         body {
            font-family: Arial, sans-serif;
            background: linear-gradient(to bottom, #ff416c, #833ab4);
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            color: #333;
        }

        .profile-container {
            display: flex; 
            width: 100%; 
            max-width: 1000px; 
            background: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
            margin: 20px auto; 
        }


        .auth-logo {
            width: 50px;
            margin-bottom: 0px;
            margin-left:-8px;
        }

        .profile-left {
            flex: 1;
            padding: 40px;
            width:500px;
            
        }

        .profile-button-a {
            display: inline-block;
            background: white;
            color: #ff416c;
            font-weight: bold;
            text-align: center;
            padding: 10px 20px;
            border-radius: 45px; 
            cursor: pointer;
            transition: background 0.3s ease, color 0.3s ease;
            border: none;
            margin-top: 10px;
            font-size: 1rem;
            width: 80%; 
        }

        .profile-button-a:hover {
            background: #f0f0f0;
            color: #e73a5b;
        }

        .profile-left h2 {
            font-size: 1.8rem;
            color: #ff416c;
            margin-bottom: 20px;
            text-align: center;
        }

        .profile-left label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }

        .profile-left input {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ddd;
            border-radius: 45px;
            font-size: 1rem;
        }

        .profile-button {
            background: #ff416c;
            color: white;
            border: none;
            width: 100%; 
            padding: 10px;
            border-radius: 45px;
            font-size: 1rem;
            cursor: pointer;
            transition: background 0.3s ease;
            margin-top: 10px;
        }

        .profile-button:hover {
            background: #e73a5b;
        }

        .error-message {
            color: red;
            font-size: 0.9rem;
            text-align: center;
            margin-top: 10px;
        }

        .profile-right {
            flex: 1;
            background: linear-gradient(to bottom, #833ab4, #ff416c);
            color: white;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            text-align: center;
            padding: 40px;
                        width:500px;

        }

        .profile-image {
            width: 180px; 
            height: 180px; 
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid white;
            margin-bottom: 20px;
        }

        .file-upload-label {
            display: inline-block;
            background: white;
            color: #ff416c;
            font-weight: bold;
            text-align: center;
            padding: 10px 20px;
            border-radius: 45px; 
            cursor: pointer;
            transition: background 0.3s ease, color 0.3s ease;
            border: none;
            margin-top: 10px;
            font-size: 1rem;
            width: 80%; 
        }

        .file-upload-label:hover {
            background: #f0f0f0;
        }

        .image-options {
            display: flex; 
            flex-direction: column;
            align-items: center;
            gap: 10px; 
            width: 100%; 
        }

        .password-container {
            position: relative;
            width: 100%;
        }

        .password-container i {
            position: absolute;
            top: 35%;
            right: 15px;
            transform: translateY(-50%);
            cursor: pointer;
            font-size: 20px;
            color: #333;
        }

        .password-container i:hover {
            color: #ff416c;
        }
    </style>
</head>
<body>
    <form id="profileForm" runat="server" enctype="multipart/form-data">
        <div class="profile-container">
            <div class="profile-left">
                <a href="index.aspx">
                    <img src="/imagens/back.png" alt="Logo" class="auth-logo">
                </a>
                <h2>Perfil</h2>
                <label for="txtUsername">Nome de Utilizador</label>
                <asp:TextBox ID="txtUsername" runat="server" placeholder="Nome de Utilizador"></asp:TextBox>
                
                <label for="txtName">Nome Completo</label>
                <asp:TextBox ID="txtName" runat="server" placeholder="Nome Completo"></asp:TextBox>
                
                <label for="txtEmail">Email</label>
                <asp:TextBox ID="txtEmail" runat="server" ReadOnly="true"></asp:TextBox>

                <label for="txtPassword">Nova Password</label>
                <div class="password-container">
                    <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" placeholder="Nova Password"></asp:TextBox>
                    <i id="togglePassword" class="fa-regular fa-eye"></i>
                </div>

                <label for="txtConfirmPassword">Confirmar Password</label>
                <div class="password-container">
                    <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" placeholder="Confirmar Password"></asp:TextBox>
                    <i id="toggleConfirmPassword" class="fa-regular fa-eye"></i>
                </div>

                <asp:Button ID="btnSave" runat="server" Text="Guardar Alterações" CssClass="profile-button" OnClick="btnSave_Click" />
                <asp:Label ID="lblMensagem" runat="server" CssClass="error-message" Visible="false"></asp:Label>
                <asp:Button ID="btnLogout" runat="server" Text="Logout" CssClass="profile-button" OnClick="btnLogout_Click" />
                <asp:Button ID="btnAdminPanel" runat="server" Text="Painel de Administração" CssClass="profile-button" OnClick="btnAdminPanel_Click" Visible="false" />
            </div>
            <div class="profile-right">
                <asp:Image ID="imgProfile" runat="server" CssClass="profile-image" ImageUrl="~/imagens/imagensPerfil/User-avatar.png" />
                <asp:FileUpload ID="fileUpload" runat="server" CssClass="file-upload" style="display: none;" />
                <label for="fileUpload" class="file-upload-label">Trocar Imagem</label>
                <div class="image-options">
                    <asp:Button ID="btnUpload" runat="server" Text="Guardar Imagem" CssClass="profile-button-a" OnClick="btnUpload_Click" />
                    <asp:Button ID="btnRemoveImage" runat="server" Text="Remover Imagem" CssClass="profile-button" OnClick="btnRemoveImage_Click" />
                </div>
            </div>
        </div>
    </form>
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const togglePassword = document.getElementById("togglePassword");
            const passwordField = document.getElementById("<%= txtPassword.ClientID %>");

            const toggleConfirmPassword = document.getElementById("toggleConfirmPassword");
            const confirmPasswordField = document.getElementById("<%= txtConfirmPassword.ClientID %>");

            togglePassword.addEventListener("click", function () {
                if (passwordField.type === "password") {
                    passwordField.type = "text";
                    togglePassword.classList.remove("fa-eye");
                    togglePassword.classList.add("fa-eye-slash");
                } else {
                    passwordField.type = "password";
                    togglePassword.classList.remove("fa-eye-slash");
                    togglePassword.classList.add("fa-eye");
                }
            });

            toggleConfirmPassword.addEventListener("click", function () {
                if (confirmPasswordField.type === "password") {
                    confirmPasswordField.type = "text";
                    toggleConfirmPassword.classList.remove("fa-eye");
                    toggleConfirmPassword.classList.add("fa-eye-slash");
                } else {
                    confirmPasswordField.type = "password";
                    toggleConfirmPassword.classList.remove("fa-eye-slash");
                    toggleConfirmPassword.classList.add("fa-eye");
                }
            });
        });
    </script>
</body>
</html>
