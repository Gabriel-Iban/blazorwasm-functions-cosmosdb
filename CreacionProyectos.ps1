#creación del los proyectos
#$NombreComun="ejemplo3"
#$UsuarioGitHub ="Gabriel-Iban"

if(( $null -eq $NombreComun) -or ($null -eq $UsuariosGitHub)){
    $NombreComun = Read-Host "Nombre común de los proyectos"
    $UsuarioGitHub = Read-Host "Nombre de Usuario de GitHub"
    $DirectorioDondeSeCrearanLosProyectos = Read-Host "Directorio con la ruta completa donde se crearán los proyectos"
    cd $DirectorioDondeSeCrearanLosProyectos
}

$NombreCliente=$NombreComun + "BlazorWasm"
$NombreApi=$NombreComun + "Api"
$NombreModel=$NombreComun + "Model"

gh repo create $NombreCliente --private
gh repo create $NombreApi --private
gh repo create $NombreModel --private

git clone https://github.com/$UsuarioGitHub/$NombreCliente.git
git clone https://github.com/$UsuarioGitHub/$NombreApi.git
git clone https://github.com/$UsuarioGitHub/$NombreModel.git

#Model
cd $NombreModel
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
cd $NombreCliente
dotnet new sln
dotnet new gitignore
dotnet new blazorwasm -o $NombreCliente
dotnet sln add $NombreCliente
git submodule add https://github.com/$UsuarioGitHub/$NombreModel.git $NombreModel
dotnet sln add $NombreModel
git add .
git commit -m"Commit inicial"
git push
cd ..

#Api con functions
cd $NombreApi
dotnet new sln
dotnet new gitignore
md $NombreApi
cd $NombreApi
func init --worker-runtime dotnet-isolated --language c#-isolated
func function new --name GetWeather --authlevel anonymous --template HttpTrigger
cd ..
dotnet sln add $NombreApi
git submodule add https://github.com/$UsuarioGitHub/$NombreModel.git $NombreModel
dotnet sln add $NombreModel
git add .
git commit -m"Commit inicial"
git push
cd ..
