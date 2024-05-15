#creación del los proyectos

$Env:NombreComun = Read-Host "Nombre común de los proyectos"
$Env:UsuarioGitHub = Read-Host "Nombre de Usuario de GitHub"
$Env:DirectorioDondeSeCrearanLosProyectos = Read-Host "Directorio con la ruta completa donde se crearán los proyectos"
Set-Location $Env:DirectorioDondeSeCrearanLosProyectos

$Env:NombreCliente=$NombreComun + "BlazorWasm"
$Env:NombreApi=$NombreComun + "Api"
$Env:NombreModel=$NombreComun + "Model"

gh repo create $Env:NombreCliente --private
gh repo create $Env:NombreApi --private
gh repo create $Env:NombreModel --private

git clone https://github.com/$Env:UsuarioGitHub/$Env:NombreCliente.git
git clone https://github.com/$Env:UsuarioGitHub/$Env:NombreApi.git
git clone https://github.com/$Env:UsuarioGitHub/$Env:NombreModel.git

#Model
Set-Location $Env:NombreModel
dotnet new sln
dotnet new gitignore
dotnet new classlib
dotnet new class --name Weather
dotnet sln add .
git add .
git commit -m"Commit inicial"
git push
Set-Location ..

#Cliente blazorwasm
Set-Location $Env:NombreCliente
dotnet new sln
dotnet new gitignore
dotnet new blazorwasm -o $Env:NombreCliente
dotnet sln add $Env:NombreCliente

git submodule add https://github.com/$Env:UsuarioGitHub/$Env:NombreModel.git

dotnet sln add $Env:NombreModel
git add .
git commit -m"Commit inicial"
git push
Set-Location ..

#Api con functions
Set-Location $Env:NombreApi
dotnet new sln
dotnet new gitignore
mkdir $Env:NombreApi
Set-Location $Env:NombreApi
func init --worker-runtime dotnet-isolated --language c#-isolated
func function new --name GetWeather --authlevel anonymous --template HttpTrigger
Set-Location ..
dotnet sln add $Env:NombreApi
git submodule add https://github.com/$Env:UsuarioGitHub/$Env:NombreModel.git 
dotnet sln add $Env:NombreModel
git add .
git commit -m"Commit inicial"
git push
Set-Location ..
