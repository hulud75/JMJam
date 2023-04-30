# JMJam
JM Jam

## Installation

Installer Lua Löve:
https://github.com/love2d/love/releases/download/11.4/love-11.4-win64.exe

Installer Git For Windows:
https://github.com/git-for-windows/git/releases/download/v2.40.1.windows.1/Git-2.40.1-64-bit.exe

Executer `Git Bash`

Cloner le dépot du jeu:
`git clone git@github.com:hulud75/JMJam.git`

## Lancer le jeu

Entrer dans le répertoire du jeu:
`cd JMJam`

Lancer le jeu:
`love .`

## Distribution

Pour créer un archive prête à être distribuée pour windows, utilisez le script powershell build.ps1
Il prend 2 arguments optionnels:
- le nom du jeu
- le chemin vers l'exe Love (on essaie de le trouver automatiquement sinon)
