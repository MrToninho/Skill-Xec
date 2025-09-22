<%@ Page Language="C#" AutoEventWireup="true" CodeFile="login.aspx.cs" Inherits="ProjetoFinalPAP.login" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Skill Xec - Login</title>
    <link rel="icon" type="image/png" href="imagens/skill-xec-logo.ico">
    <link rel="stylesheet" href="/css/styles.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(to bottom, #ff416c, #833ab4); 
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            color: #333;
        }

        .auth-container {
            display: flex;
            width: 90%;
            max-width: 900px;
            background: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
        }

        .auth-left {
            flex: 1;
            padding: 40px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: flex-start;
            background: white;
        }

        .auth-logo {
            width: 50px;
            margin-bottom: 20px;
            margin-left:-8px;
        }

        .auth-header h2 {
            font-size: 1.8rem;
            margin-bottom: 10px;
        }

        .auth-header p {
            font-size: 1rem;
            margin-bottom: 30px;
            color: #777;
        }

        .auth-form {
            width: 100%;
        }

        .auth-form label {
            display: block;
            margin-bottom: 5px;
            font-size: 0.9rem;
            color: #555;
        }

        .auth-form input {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ddd;
            border-radius: 45px;
            font-size: 1rem;
        }

        .auth-button {
            background: #ff416c;
            color: white;
            border: none;
            width: 100%;
            padding: 10px;
            border-radius: 45px;
            font-size: 1rem;
            cursor: pointer;
            transition: background 0.3s ease;
        }

        .auth-button:hover {
            background: #e73a5b;
        }

        .error-message {
            color: red;
            font-size: 0.9rem;
            text-align: center;
            margin-top: 10px;
            height: 40px; 
            display: flex;
            align-items: center;
            justify-content: center;
            width: 100%; 
            white-space: nowrap; 
            overflow: hidden; 
            text-overflow: ellipsis; 
        }

        .auth-links {
            margin-top: 10px;
            font-size: 0.9rem;
            text-align: center;
        }

        .auth-links a {
            color: #007bff;
            text-decoration: none;
        }

        .auth-links a:hover {
            text-decoration: underline;
        }

        .auth-right {
            flex: 1;
            background: linear-gradient(to bottom, #833ab4, #ff416c);
            color: white;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            padding: 40px;
            text-align: center;
        }

        .auth-image {
            width: 60%;
            margin-bottom: 20px;
        }

        .auth-right h3 {
            font-size: 1.5rem;
            margin-bottom: 10px;
        }

        .auth-right p {
            font-size: 1rem;
            line-height: 1.5;
        }

        .forgot-password {
            display: block;
            margin: 5px 0 20px; 
            font-size: 0.9rem;
            color: #007bff;
            text-decoration: none;
        }

        .forgot-password:hover {
            text-decoration: underline;
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

        .google-button {
            display: flex;
            align-items: center;
            justify-content: center;
            background: white;
            border: 1px solid #ddd;
            border-radius: 35px;
            padding: 10px;
            font-size: 1rem;
            color: #555;
            text-decoration: none;
            margin-bottom: 20px;
            cursor: pointer;
            transition: background 0.3s ease;
            margin-top:15px;
        }

        .google-button img {
            width: 20px;
            margin-right: 10px;
        }

        .google-button:hover {
            background: #f7f7f7;
        }

    </style>
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const togglePassword = document.getElementById("togglePasswordLogin");
            const passwordField = document.getElementById("<%= txtPassword.ClientID %>");

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
        });
    </script>
</head>
<body>
    <div class="auth-container">
        <div class="auth-left">
            <div class="auth-header">
                <a href="index.aspx">
                    <img src="/imagens/back.png" alt="Logo" class="auth-logo">
                </a>
                <h2>Bem-vindo à Skill Xec</h2>
            </div>
            <form id="loginForm" runat="server" class="auth-form">
                <label for="txtEmail">Email</label>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="input" placeholder="Email" required="true"></asp:TextBox>
                <label for="txtPassword">Palavra-passe</label>
                <div class="password-container">
                    <asp:TextBox ID="txtPassword" runat="server" CssClass="input" TextMode="Password" placeholder="Palavra-passe" required="true"></asp:TextBox>
                    <i id="togglePasswordLogin" class="fa-regular fa-eye"></i>
                </div>
                <asp:Button ID="btnLogin" runat="server" OnClick="btnLogin_Click" CssClass="auth-button" Text="Iniciar Sessão" />
                <asp:Label ID="lblMensagem" runat="server" CssClass="error-message" Visible="false"></asp:Label>
                <div class="auth-links">
                    <a href="register.aspx">Ainda não tem conta? Registe-se aqui!</a><br />
                      <asp:LinkButton ID="btnLoginGoogle" runat="server" CssClass="google-button" OnClick="btnLoginGoogle_Click">
                        <img src="/imagens/google-icon.svg" alt="Google Icon" style="width: 20px; margin-right: 8px;">
                        Login com Google
                    </asp:LinkButton>
                    <a href="recuperarPassword.aspx" class="forgot-password">Esqueceu-se da palavra-passe?</a>
                </div>
            </form>
        </div>
        <div class="auth-right">
            <img src="/imagens/login.png" alt="Illustration" class="auth-image">
            <h3>Veja tutoriais e guias informativos de jogos</h3>
            <p>Explore e compartilhe seus momentos favoritos em vídeo.</p>
        </div>
    </div>
</body>
</html>
