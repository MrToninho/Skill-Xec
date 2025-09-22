<%@ Page Language="C#" AutoEventWireup="true" CodeFile="register.aspx.cs" Inherits="ProjetoFinalPAP.register" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Skill Xec - Registo</title>
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
    width: 80%;
    max-width: 1200px;
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

.auth-form label {
    display: block;
    margin-bottom: 5px;
    font-size: 0.9rem;
    color: #555;
}

.auth-form input {
    width: 100%;
    padding: 10px;
    margin-bottom: 20px;
    border: 1px solid #ddd;
    border-radius: 45px;
    font-size: 1rem;
}

.auth-button {
    background: #ff416c;
    color: white;
    border: none;
    padding: 10px 20px;
    border-radius: 5px;
    font-size: 1rem;
    cursor: pointer;
    transition: background 0.3s ease;
}

.auth-button:hover {
    background: #e73a5b;
}

.auth-links {
    margin-top: 10px;
    font-size: 0.9rem;
}

.auth-links a {
    color: #007bff;
    text-decoration: none;
    margin-right: 15px;
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
    color: white;
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

.error-message {
    color: red;
    font-size: 0.9rem;
    margin-top: -15px;
    margin-bottom: 20px;
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
        function validatePassword() {
            const password = document.getElementById("<%=txtPassword.ClientID%>").value;
            const confirmPassword = document.getElementById("<%=txtConfirmPassword.ClientID%>").value;
            const errorMessage = document.getElementById("passwordError");

            const passwordRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+\-=[\]{};':"\\|,.<>/?]).{8,20}$/;

            if (!passwordRegex.test(password)) {
                errorMessage.textContent = "A palavra-passe deve ter entre 8-20 caracteres, incluir pelo menos uma letra maiúscula, uma letra minúscula, um número e um símbolo.";
                return false;
            } else if (password !== confirmPassword) {
                errorMessage.textContent = "As palavras-passe não coincidem.";
                return false;
            }

            errorMessage.textContent = "";
            return true;
        }

        document.addEventListener("DOMContentLoaded", function () {
            const togglePassword = document.getElementById("togglePassword");
            const passwordField = document.getElementById("<%=txtPassword.ClientID%>");

            const toggleConfirmPassword = document.getElementById("toggleConfirmPassword");
            const confirmPasswordField = document.getElementById("<%=txtConfirmPassword.ClientID%>");

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
</head>
<body>
    <div class="auth-container">
        <div class="auth-left">
            <div class="auth-header">
                <a href="login.aspx">
                    <img src="/imagens/back.png" alt="Logo" class="auth-logo">
                </a>
                <h2>Bem-vindo à Skill Xec</h2>
            </div>
            <form id="registerForm" runat="server" class="auth-form" onsubmit="">
                <div style="display: flex; gap: 10px;">
                    <div style="flex: 1;">
                        <label for="txtFirstName">Primeiro Nome</label>
                        <asp:TextBox ID="txtFirstName" runat="server" CssClass="input" placeholder="Primeiro Nome" required="true"></asp:TextBox>
                    </div>
                    <div style="flex: 1;">
                        <label for="txtLastName">Último Nome</label>
                        <asp:TextBox ID="txtLastName" runat="server" CssClass="input" placeholder="Último Nome" required="true"></asp:TextBox>
                    </div>
                </div>
                <label for="txtUsername">Nome de Utilizador</label>
                <asp:TextBox ID="txtUsername" runat="server" CssClass="input" placeholder="Nome de Utilizador" required="true"></asp:TextBox>
                <label for="txtEmail">Email</label>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="input" TextMode="Email" placeholder="Email" required="true"></asp:TextBox>
                <label for="txtPassword">Palavra-passe</label>
                <div class="password-container">
                    <asp:TextBox ID="txtPassword" runat="server" CssClass="input" TextMode="Password" placeholder="Palavra-passe" required="true"></asp:TextBox>
                    <i id="togglePassword" class="fa-regular fa-eye"></i>
                </div>
                <label for="txtConfirmPassword">Confirmar Palavra-passe</label>
                <div class="password-container">
                    <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="input" TextMode="Password" placeholder="Confirme a sua palavra-passe" required="true"></asp:TextBox>
                    <i id="toggleConfirmPassword" class="fa-regular fa-eye"></i>
                </div>
                <p id="passwordError" class="error-message"></p>
                <asp:Button ID="btnCriarConta" runat="server" OnClick="btnCriarConta_Click" CssClass="auth-button" Text="Registar" />
                <asp:Label ID="lblMensagem" runat="server" CssClass="error-message" Visible="false"></asp:Label>
                <div class="auth-links">
                      <asp:LinkButton ID="btnRegiserGoogle" runat="server" CssClass="google-button" OnClick="btnRegisterGoogle_Click">
                        <img src="/imagens/google-icon.svg" alt="Google Icon" style="width: 20px; margin-right: 8px;">
                        Registar com Google
                    </asp:LinkButton>
                    <a href="login.aspx">Já tens uma conta? Inicia sessão aqui!</a>
                </div>
            </form>
        </div>
        <div class="auth-right">
            <img src="/imagens/login.png" alt="Illustration" class="auth-image">
            <h3>Junte-se hoje</h3>
            <p>Faça parte da comunidade Skill Xec.</p>
        </div>
    </div>
</body>
</html>
