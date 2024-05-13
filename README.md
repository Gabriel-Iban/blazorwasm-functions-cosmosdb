# blazorwasm-functions-cosmosdb
En este repositorio iré dejando las instrucciones para crear una aplicación de prueba que se pueda subir a Azure y que, de forma gratuita, nos permita construir una aplicación funcional con las tres tecnologías de Blazor Wasm, Azure Functions, y Cosmos DB

Hay un fichero configuracionMaquina.ps1 en el que dejo los paso para configurar la máquina de desarrollo. Se han probado en la máquina virtual de microsoft de desarrollo que se puede ejecutar con Hyper-v.
Otro fichero con los primeros pasos para crear los proyectos que describo aquí:

Habría que fijar estas dos variables
<code>
$NombreComun="ejemplo4"
$UsuarioGitHub ="Gabriel-Iban"
</code>
Y ejecutar todo esto o copiarlo y pegarlo
<code>
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

</code>
# Ejecutar la solución Model
<code>
namespace Model;
public class Weather
{
    public DateOnly Date { get; set; }
    public int TemperatureC { get; set; }
    public string? Summary { get; set; }
    public int TemperatureF => 32 + (int)(TemperatureC / 0.5556);
}
</code>
# En Api
Instalar según:
https://learn.microsoft.com/en-us/azure/azure-functions/dotnet-isolated-process-guide?tabs=windows#aspnet-core-integration
El paquete 
Microsoft.Azure.Functions.Worker.Extensions.Http.AspNetCore
Actualizar 
Microsoft.Azure.Functions.Worker.Sdk
Microsoft.Azure.Functions.Worker

<code>
using Microsoft.AspNetCore.Http;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Logging;
using Model;
using Microsoft.AspNetCore.Mvc;

namespace Api {
    public class HttpTriggerCSharp {
        ILogger _logger;

        public HttpTriggerCSharp(ILogger<HttpTriggerCSharp> logger) {
            _logger = logger;
        }
        [Function("Weather")]
        public IActionResult Get([HttpTrigger(AuthorizationLevel.Anonymous, "get")] HttpRequest req) {
            _logger.LogInformation("hola");
            return new JsonResult(this.getlWheather());
            //return new JsonResult(new Wheather() { Date = new DateOnly(2024, 4, 12), TemperatureC = 10, Summary = "Temperatura 1" });
        }

        private List<Weather> getlWheather() {
            List<Weather> result = new();
            result.Add(new Weather() { Date = new DateOnly(2024, 4, 12), TemperatureC = 10, Summary = "Temperatura desde api 1" });
            result.Add(new Weather() { Date = new DateOnly(2024, 4, 13), TemperatureC = 20, Summary = "Temperatura desde api 2" });
            result.Add(new Weather() { Date = new DateOnly(2024, 4, 14), TemperatureC = 30, Summary = "Temperatura desde api 3" });

            return result;
        }

    }
}
/*
using System.Net;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Azure.Functions.Worker.Http;
using Microsoft.Extensions.Logging;

namespace Api
{
    public class GetWeather
    {
        private readonly ILogger _logger;

        public GetWeather(ILoggerFactory loggerFactory)
        {
            _logger = loggerFactory.CreateLogger<GetWeather>();
        }

        [Function("GetWeather")]
        public HttpResponseData Run([HttpTrigger(AuthorizationLevel.Anonymous, "get", "post")] HttpRequestData req)
        {
            _logger.LogInformation("C# HTTP trigger function processed a request.");

            var response = req.CreateResponse(HttpStatusCode.OK);
            response.Headers.Add("Content-Type", "text/plain; charset=utf-8");

            response.WriteString("Welcome to Azure Functions!");

            return response;
        }
    }
}
*/


Program de Api
using Microsoft.Extensions.Hosting;

var host = new HostBuilder()
    .ConfigureFunctionsWebApplication()
//    .ConfigureFunctionsWorkerDefaults()
    .Build();

host.Run();

Según: How to configure CORS in Azure function app? - Stack Overflow

Local.setting.json
{
    "IsEncrypted": false,
    "Values": {
        "AzureWebJobsStorage": "UseDevelopmentStorage=true",
        "FUNCTIONS_WORKER_RUNTIME": "dotnet-isolated"
    },
    "Host": {
        "CORS": "*"
    }
}

</code>
