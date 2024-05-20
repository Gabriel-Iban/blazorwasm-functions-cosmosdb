# blazorwasm-functions-cosmosdb
En este repositorio iré dejando las instrucciones para crear una aplicación de prueba que se pueda subir a Azure y que, de forma gratuita, nos permita construir una aplicación funcional con las tres tecnologías de Blazor Wasm, Azure Functions, y Cosmos DB

Hay un fichero configuracionMaquina.ps1 en el que dejo los paso para configurar la máquina de desarrollo. Se han probado en la máquina virtual de microsoft de desarrollo que se puede ejecutar con Hyper-v.
Otro fichero con los primeros pasos para crear los proyectos que describo aquí:

# Fichero creacionProyectos.ps1
Pegar código en el fichero readme.md da problemas si luego lo copiamos y lo pegamos. Por ello explico qué hace, pero el código lo dejo en los ficheros correspondientes.

Podemos fijar las variables en código o responder a las preguntas para la creación de los proyectos y repositorios.

Para trabajar con creacionProyectos.ps1 hay que tener instalado y configurado github-cli

Inicialmente este script creaba 3 repositorios en github pero al subir los proyectos en azure da problemas con los submodulos de git (que por cierto no es la primera vez que me dan problemas los submodulos) así que, como "solución" o más bien "parche" de compromiso creo dos. Servidor y cliente. Los ficheros de "Model" que serían comunes se copiarán desde el proyecto de servidor al proyecto de cliente para poderlos utilizar.

Es necesario tener un proyecto github independiente para blazor y otro para functions por la manera en que se suben a Azure.

En una StaticWebApplication de Azure se puede incluir una api pero lo estamos haciendo de forma externa para acercarnos más a cómo se haría en la realidad. Es decir, con herramientas gratuitas pero que se parezcan los máximo posible a las soluciones de pago que realmente se usarían.

**** Ibas por aquí. Hay que cambiar el fuente y ver qué se cambia en la documentación.

# Solución Model
Abrimos esta solución y podremos crear una clase, o copiar el fichero de DeModel en este repositorio para tener una clase común a las otras dos soluciones que aporte el modelo común que van a utilizar.
Ya hay creada una clase Weather por el script de creación.
Grabamos y salimos.

# Solución Api
Abrimos la solución y aquí, extrañamente hay muchas cosas que cambiar dado que la plantilla que se crea está muy desactualiada. 
Recomiendo copiar los ficheros de este mismo proyecto para no teclear errores que puedan ser difíciles de detectar.
La guía para hacer todo esto sale de https://learn.microsoft.com/en-us/azure/azure-functions/dotnet-isolated-process-guide?tabs=windows#aspnet-core-integration
# En la propia solución
Añadir el paquete nuget Microsoft.Azure.Functions.Worker.Extensions.Http.AspNetCore

Actualizar 
* Microsoft.Azure.Functions.Worker.Sdk
* Microsoft.Azure.Functions.Worker

# en el fichero 


Una vez creadas las soluciones...

#Crear Infraestructura en Azure

Hay que tener creadas las variables de:
$UsuarioGitHub
$NombreCliente
$NombreApi

install-module -Name az

connect-AzAccount -SubscriptionId [tu-id-de-subscripción]

$staticWebApp = New-AzStaticWebApp -ResourceGroupName $resourcegroup -Name 'borrame1827328' -Location $location -RepositoryUrl "https://github.com/$UsuarioGitHub/$NombreCliente.git" -Branch "master" -AppLocation 'Client' -ApiLocation 'Api' -OutputLocation 'wwwroot' -SkuName 'Free'

Write-Host $staticWebApp.DefaultHostname


