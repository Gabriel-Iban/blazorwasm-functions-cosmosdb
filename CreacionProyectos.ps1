#creación del los proyectos

$Env:NombreComun = Read-Host "Nombre común de los proyectos"
$Env:UsuarioGitHub = Read-Host "Nombre de Usuario de GitHub"
$Env:DirectorioLocal = Read-Host "Directorio con la ruta completa donde se crearán los proyectos"
Set-Location $Env:DirectorioLocal

$Env:NombreCliente=$Env:NombreComun + "BlazorWasm"
$Env:NombreApi=$Env:NombreComun + "Functions"
$Env:NombreModel=$Env:NombreComun + "Model"

gh repo create $Env:NombreCliente --private
gh repo create $Env:NombreApi --private

git clone https://github.com/$Env:UsuarioGitHub/$Env:NombreCliente.git
git clone https://github.com/$Env:UsuarioGitHub/$Env:NombreApi.git

#Api con functions
Set-Location $Env:NombreApi
dotnet new sln
dotnet new gitignore

mkdir $Env:NombreModel
Set-Location $Env:NombreModel
dotnet new classlib
dotnet new class --name Weather
Set-Location ..

mkdir $Env:NombreApi
Set-Location $Env:NombreApi
func init --worker-runtime dotnet-isolated --language c#-isolated
func function new --name GetWeather --authlevel anonymous --template HttpTrigger
dotnet add reference "..\$env:NombreModel"
Set-Location ..

dotnet sln add $Env:NombreApi
dotnet sln add $Env:NombreModel

git add .
git commit -m"Commit inicial"
git push
Set-Location ..


#Cliente blazorwasm
Set-Location $Env:NombreCliente
dotnet new sln
dotnet new gitignore

#Copiamos el proyecto Model. Es una chapuza pero el gitsubmodule no funciona al subir a Azure
mkdir $Env:NombreModel
Copy-Item ..\$Env:NombreApi\$Env:NombreModel\* .\$Env:NombreModel -Recurse
$GetModelContent = "Copy-Item ..\$Env:NombreApi\$Env:NombreModel\* .\$Env:NombreModel -Recurse -Force"
Set-Content -Path "GetModel.ps1" -Value $GetModelContent

dotnet new blazorwasm -o "Client" # El nombre Client no es casual. Es para luego subir a Azure
Set-Location "Client"
dotnet add reference ..\$env:NombreModel
Set-Location ..

dotnet sln add "Client"
dotnet sln add $Env:NombreModel

git add .
git commit -m"Commit inicial"
git push
Set-Location ..
