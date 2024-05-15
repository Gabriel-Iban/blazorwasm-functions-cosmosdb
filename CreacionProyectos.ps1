#creación del los proyectos

$Env:NombreComun = Read-Host "Nombre común de los proyectos"
$Env:UsuarioGitHub = Read-Host "Nombre de Usuario de GitHub"
$Env:DirectorioDondeSeCrearanLosProyectos = Read-Host "Directorio con la ruta completa donde se crearán los proyectos"
cd $Env:DirectorioDondeSeCrearanLosProyectos

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
cd $Env:NombreModel
dotnet new sln
dotnet new gitignore
dotnet new classlib
dotnet new class --name Weather
dotnet sln add .
git add .
git commit -m"Commit inicial"
git push
cd ..
#Cliente blazorwasm
cd $Env:NombreCliente
dotnet new sln
dotnet new gitignore
dotnet new blazorwasm -o $Env:NombreCliente
dotnet sln add $Env:NombreCliente
git submodule add https://github.com/$Env:UsuarioGitHub/$Env:NombreModel.git $Env:NombreModel
dotnet sln add $Env:NombreModel
git add .
git commit -m"Commit inicial"
git push
cd ..

#Api con functions
cd $Env:NombreApi
dotnet new sln
dotnet new gitignore
md $Env:NombreApi
cd $Env:NombreApi
func init --worker-runtime dotnet-isolated --language c#-isolated
func function new --name GetWeather --authlevel anonymous --template HttpTrigger
cd ..
dotnet sln add $Env:NombreApi
git submodule add https://github.com/$Env:UsuarioGitHub/$Env:NombreModel.git $Env:NombreModel
dotnet sln add $Env:NombreModel
git add .
git commit -m"Commit inicial"
git push
cd ..
