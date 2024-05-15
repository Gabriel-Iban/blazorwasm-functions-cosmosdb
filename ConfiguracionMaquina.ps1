# Instalación de la máquina
# Configurar en castellano
New-WinUserLanguageList es-ES
Set-WinUserLanguageList -LanguageList es-ES -Force

#ejecutar como administrador

//Intalación de powershell core. Resulta curioso que no venga de serie
winget install Microsoft.PowerShell -e

#ya con pwsh

//Git y GitHub
winget install -e --id Git.Git
winget install -e --id GitHub.cli

#Code por si acaso
winget install -e --id Microsoft.VisualStudioCode

#Para que se puedan crear funciones de azure
winget install -e --id Microsoft.Azure.FunctionsCoreTools

#Estoy hay que hacerlo interactivo
gh auth login

#aquí tienes que poner tus datos
git config --global user.email "you@example.com"
git config --global user.name "Gabriel-Iban"

#Creamos un directorio en C: para guardar la programación
md c:/pro
cd c:/pro
