#creación del los proyectos
$NombreComun="ejemplo3"
$UsuarioGitHub ="Gabriel-Iban"

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
cd ..
#Cliente blazorwasm
cd $NombreCliente
dotnet new sln
dotnet new gitignore
dotnet new blazorwasm -o $NombreCliente
dotnet sln add $NombreCliente
dotnet sln add ..\$NombreModel
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
dotnet sln add ..\$NombreModel
cd ..
