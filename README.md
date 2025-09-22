# 🎮 Skill Xec – Plataforma de Conteúdo Gaming

O **Skill Xec** é uma plataforma web onde os utilizadores podem partilhar conteúdos relacionados com videojogos:  
gameplays, reviews e tutoriais.  

---

## 📑 Table of Contents
- ✨ [Funcionalidades](#-funcionalidades)  
- ⚠️ [Requisitos](#️-requisitos)  
- 🛠️ [Instalação](#-instalação)  
- 🚀 [Uso](#-uso)  
- 📂 [Estrutura do Projeto](#-estrutura-do-projeto)  
- 🔧 [Troubleshooting](#-troubleshooting)  
- 🙏 [Agradecimentos](#-agradecimentos)  
- 📜 [Licença](#-licença)  

---

## ✨ Funcionalidades
- 👤 Registo, login, ativação e recuperação de conta  
- 📝 Perfis de utilizador personalizáveis  
- 📤 Upload, edição e remoção de vídeos  
- 📺 Criação de canais pessoais  
- ❤️ Adicionar vídeos aos favoritos  
- 📜 Histórico de visualizações  
- 🛠️ Painel de administração para gestão de utilizadores e conteúdos  

---

## ⚠️ Requisitos
- Visual Studio (com suporte a ASP.NET e C#)  
- SQL Server (ou SQL Server Express)  
- Navegador moderno  
- .NET Framework (versão usada no projeto)  

---

## 🛠️ Instalação
1. Clonar o repositório:  
   ```bash
   git clone https://github.com/teu-username/skill-xec.git
   cd skill-xec

2. Configurar a base de dados:

- Executar o ficheiro Skillxec.sql no SQL Server
- Atualizar a connection string em Web.config

3. Abrir no Visual Studio:

- Abrir ProjetoFinalPAP.sln
- Definir ProjetoFinalPAP como Startup Project

4. Executar a aplicação:

- Correr com IIS Express ou outro servidor configurado
- Aceder em http://localhost:xxxx
  
---

## 🚀 Uso

- Criar uma conta ou fazer login
- Publicar vídeos (gameplays, tutoriais ou reviews)
- Explorar canais de outros utilizadores
- Guardar vídeos em favoritos e consultar histórico
- Administradores podem gerir conteúdos no painel de administração

---

##📂 Estrutura do Projeto

ProjetoFinalPAP/
 ├── ProjetoFinalPAP.sln        # Ficheiro da solução
 ├── Skillxec.sql               # Script da base de dados
 ├── ProjetoFinalPAP/           # Código principal
 │   ├── index.aspx             # Página inicial
 │   ├── login.aspx             # Autenticação
 │   ├── register.aspx          # Registo
 │   ├── perfil.aspx            # Perfil do utilizador
 │   ├── canal.aspx             # Canal do utilizador
 │   ├── favoritos.aspx         # Favoritos
 │   ├── historico.aspx         # Histórico
 │   ├── editar-video.aspx      # Edição de vídeos
 │   ├── admin.aspx             # Administração
 │   └── Web.config             # Configurações

---

## 🔧 Troubleshooting
⚠️ Erro na conexão à BD: verificar Web.config e se o SQL Server está ativo
⚠️ Problemas de autenticação: confirmar que o script Skillxec.sql foi corrido corretamente
⚠️ Problemas de login e registo via Google: no login.aspx.cs e no register.aspx.cs, terá que mudar para o seu Google Client ID e Password para que funcione

---

## 🙏 Agradecimentos
- Professores e colegas que apoiaram o desenvolvimento da PAP
- Comunidade ASP.NET e documentação da Microsoft

---

## 📜 Licença
Este projeto foi desenvolvido para fins académicos da ATEC no âmbito da Prova de Aptidão Profissional (PAP).
