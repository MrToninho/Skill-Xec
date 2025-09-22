# 🎮 Skill Xec – Gaming Content Platform

**Skill Xec** is a web platform where users can share video game-related content:  
gameplays, reviews, and tutorials.  

---

## 📑 Table of Contents
- ✨ [Features](#-features)  
- ⚠️ [Requirements](#️-requirements)  
- 🛠️ [Installation](#-installation)  
- 🚀 [Usage](#-usage)  
- 📂 [Project Structure](#-project-structure)  
- 🔧 [Troubleshooting](#-troubleshooting)  
- 🙏 [Acknowledgments](#-acknowledgments)  

---

## ✨ Features
- 👤 Registration, login, activation, and account recovery  
- 📝 Customizable user profiles  
- 📤 Video upload, editing, and removal  
- 📺 Personal channel creation  
- ❤️ Add videos to favorites  
- 📜 Viewing history  
- 🛠️ Admin panel for user and content management  

---

## ⚠️ Requirements
- Visual Studio (with ASP.NET and C# support)  
- SQL Server (or SQL Server Express)  
- Modern browser  
- .NET Framework (version used in the project)  

---

## 🛠️ Installation
1. Clone the repository:
```bash
  git clone https://github.com/teu-username/skill-xec.git
  cd skill-xec
```
2. Configure the database:

- Run the Skillxec.sql file in SQL Server
- Update the connection string in Web.config

3. Open in Visual Studio:

- Open ProjetoFinalPAP.sln
- Set ProjetoFinalPAP as Startup Project

4. Run the application:

- Run with IIS Express or another configured server
- Access at http://localhost:xxxx
  
---

## 🚀 Usage

- Create an account or log in
- Publish videos (gameplays, tutorials, or reviews)
- Explore other users' channels
- Save videos to favorites and view history
- Administrators can manage content in the admin panel

---

##📂 Project Structure
```bash

Skill-Xec/
│
├── ProjetoFinalPAP.sln          # Visual Studio solution file
├── Skillxec.sql                 # Script to create and configure the database
│
├── ProjetoFinalPAP/             # Main application code
│   ├── index.aspx               # Home page
│   ├── login.aspx               # Authentication page
│   ├── register.aspx            # User registration
│   ├── profile.aspx             # User profile
│   ├── channel.aspx             # User's personal channel
│   ├── favorites.aspx           # List of favorite videos
│   ├── history.aspx             # Viewing history
│   ├── edit-video.aspx          # Video editing
│   ├── admin.aspx               # Administration panel
│   ├── Web.config               # Application configuration (includes connection string)
│   └── (other ASPX files + assets)
│
├── bin/                         # Compiled files
├── obj/                         # Temporary build objects
└── README.md                    # Project documentation
```

---

## 🔧 Troubleshooting
- Database connection error: check Web.config and whether SQL Server is active
- Authentication issues: confirm that the Skillxec.sql script has been run correctly
- Login and registration issues via Google: in login.aspx.cs and register.aspx.cs, you will need to change to your Google Client ID and Password for it to work

---

## 🙏 Acknowledgments
- Teachers and colleagues who supported the development of PAP
- ASP.NET community and Microsoft documentation




Translated with DeepL.com (free version)
