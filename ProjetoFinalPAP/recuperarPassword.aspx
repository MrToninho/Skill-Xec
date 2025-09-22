<%@ Page Language="C#" AutoEventWireup="true" CodeFile="recuperarPassword.aspx.cs" Inherits="ProjetoFinalPAP.recuperarPassword" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Skill Xec - Recuperar Palavra-Passe</title>
    <link rel="icon" type="image/png" href="imagens/skill-xec-logo.ico">
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
            margin-left: -8px;
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
            line-height: 1.4; 
            height: auto; 
            display: flex;
            flex-direction: column; 
            align-items: center;
            justify-content: center;
            width: 100%; 
            white-space: normal; 
            overflow-wrap: break-word; 
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
    </style>
    <script>
        function validarPassword() {
            const novaPassword = document.getElementById('<%= txtNovaPassword.ClientID %>').value;
            const confirmarPassword = document.getElementById('<%= txtConfirmarPassword.ClientID %>').value;
            const errorLabel = document.getElementById('<%= lblMensagemRedefinir.ClientID %>');

            const regex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,20}$/;

            if (!regex.test(novaPassword)) {
                errorLabel.innerText = "A palavra-passe deve ter entre 8-20 caracteres, incluir pelo menos uma letra maiúscula, uma letra minúscula, um número e um símbolo.";
                errorLabel.style.display = "block";
                return false;
            }

            if (novaPassword !== confirmarPassword) {
                errorLabel.innerText = "As palavras-passe não coincidem. Por favor, tente novamente.";
                errorLabel.style.display = "block";
                return false;
            }

            errorLabel.style.display = "none";
            return true;
        }

            document.getElementById('<%= txtNovaPassword.ClientID %>').addEventListener('input', function () {
                    document.getElementById('<%= lblMensagemRedefinir.ClientID %>').innerText = '';
            });

            document.getElementById('<%= txtConfirmarPassword.ClientID %>').addEventListener('input', function () {
                document.getElementById('<%= lblMensagemRedefinir.ClientID %>').innerText = '';
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
                <h2 id="form-title">Recuperar Palavra-Passe</h2>
                <p id="form-description">Digite o email associado à sua conta para redefinir a sua palavra-passe.</p>
            </div>
            
            <!-- Formulário de recuperação -->
            <form id="recuperarPasswordEmailForm" runat="server" class="auth-form" autocomplete="off" visible="true">
                <label for="txtEmail">Email</label>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="input" placeholder="Email" required="true" autocomplete="off"></asp:TextBox>
                <asp:Button ID="btnRecuperar" runat="server" OnClick="btnRecuperar_Click" CssClass="auth-button" Text="Recuperar Palavra-Passe" />
                <asp:Label ID="lblMensagemRecuperar" runat="server" CssClass="error-message" Visible="false"></asp:Label>
            </form>

            <!-- Formulário de redefinição -->
            <form id="redefinirPasswordForm" runat="server" class="auth-form" visible="false" autocomplete="off">
                <label for="txtNovaPassword">Nova Palavra-Passe</label>
                <asp:TextBox ID="txtNovaPassword" runat="server" CssClass="input" TextMode="Password" placeholder="Nova palavra-passe" required="true" autocomplete="new-password" name="txtNovaPassword"></asp:TextBox>
                <label for="txtConfirmarPassword">Confirmar Palavra-Passe</label>
                <asp:TextBox ID="txtConfirmarPassword" runat="server" CssClass="input" TextMode="Password" placeholder="Confirme a nova palavra-passe" required="true" autocomplete="new-password" name="txtConfirmarPassword"></asp:TextBox>                <asp:Button ID="btnAlterarPassword" runat="server" OnClick="btnAlterarPassword_Click" CssClass="auth-button" Text="Redefinir Palavra-Passe" />
                <asp:Label ID="lblMensagemRedefinir" runat="server" CssClass="error-message" Visible="false"></asp:Label>
            </form>
        </div>
        <div class="auth-right">
            <img src="/imagens/login.png" alt="Illustration" class="auth-image">
            <h3>Redefina a sua Palavra-Passe</h3>
            <p>Receberá instruções para redefinir sua palavra-passe em instantes.</p>
        </div>
    </div>
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const passwordField = document.getElementById("<%= txtNovaPassword.ClientID %>");
            const confirmPasswordField = document.getElementById("<%= txtConfirmarPassword.ClientID %>");

            passwordField.setAttribute("autocomplete", "new-password");
            confirmPasswordField.setAttribute("autocomplete", "new-password");
        });

            </script>
</body>
</html>
