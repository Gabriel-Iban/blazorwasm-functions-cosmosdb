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

#Parece compilar sin acceder a paquetes fuera. Esto añade otro origen de paquetes
dotnet nuget add source https://api.nuget.org/v3/index.json -n nuget.org
#Se puede ver con dotnet nuget list source


#Estoy hay que hacerlo interactivo
gh auth login


#Creamos un directorio en C: para guardar la programación
md c:/pro
cd c:/pro
