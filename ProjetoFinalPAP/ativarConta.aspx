<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ativarConta.aspx.cs" Inherits="ProjetoFinalPAP.ativarConta" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Skill Xec - Ativar Conta</title>
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

        .error-message {
            color: red;
            font-size: 0.9rem;
            margin-top: 15px;
        }

        .success-message {
            color: green;
            font-size: 1rem;
            margin-top: 15px;
        }
    </style>
</head>
<body>
    <div class="auth-container">
        <div class="auth-left">
            <div class="auth-header">
                <a href="index.aspx">
                    <img src="/imagens/back.png" alt="Logo" class="auth-logo">
                </a>
                <h2>Ativar Conta</h2>
            </div>
            <form id="activateAccountForm" runat="server" class="auth-form">
                <asp:Label ID="lblMensagem" runat="server" CssClass="error-message" Visible="false"></asp:Label>
                <asp:Label ID="lblSucesso" runat="server" CssClass="success-message" Visible="false"></asp:Label>
                <asp:Button ID="btnVoltarLogin" runat="server" CssClass="auth-button" Text="Voltar ao Login" OnClick="btnVoltarLogin_Click" Visible="false" />
            </form>
        </div>
        <div class="auth-right">
            <img src="/imagens/login.png" alt="Illustration" class="auth-image">
            <h3>Ative sua conta</h3>
            <p>Obrigado por se registar no Skill Xec! <br> Clique no botão abaixo para completar o processo de ativação da conta.</p>
        </div>
    </div>
</body>
</html>
