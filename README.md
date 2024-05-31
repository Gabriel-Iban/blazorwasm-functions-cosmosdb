# blazorwasm-functions-cosmosdb
En este repositorio iré dejando las instrucciones para crear una aplicación de prueba que se pueda subir a Azure y que, de forma gratuita, nos permita construir una aplicación funcional con las tres tecnologías de Blazor Wasm, Azure Functions, y Cosmos DB

Hay un fichero configuracionMaquina.ps1 en el que dejo los paso para configurar la máquina de desarrollo. Se han probado en la máquina virtual de microsoft de desarrollo que se puede ejecutar con Hyper-v.
Otro fichero con los primeros pasos para crear los proyectos que describo aquí:

# Fichero creacionProyectos.ps1
Pegar código en el fichero readme.md da problemas si luego lo copiamos y lo pegamos. Por ello explico qué hace, pero el código lo dejo en los ficheros correspondientes.

Para trabajar con creacionProyectos.ps1 hay que tener instalado y configurado github-cli

Inicialmente este script creaba 3 repositorios en github pero al subir los proyectos en azure da problemas con los submodulos de git (que por cierto no es la primera vez que me dan problemas los submodulos) así que, como "solución" o más bien "parche" de compromiso creo dos. Servidor y cliente. Los ficheros de "Model" que serían comunes se copiarán desde el proyecto de servidor al proyecto de cliente para poderlos utilizar.

Es necesario tener un proyecto github independiente para blazor y otro para functions por la manera en que se suben a Azure.

En una StaticWebApplication de Azure se puede incluir una api pero lo estamos haciendo de forma externa para acercarnos más a cómo se haría en la realidad. Es decir, con herramientas gratuitas pero que se parezcan los máximo posible a las soluciones de pago que realmente se usarían.

# Solución Functions
La guía para hacer todo esto sale de https://learn.microsoft.com/en-us/azure/azure-functions/dotnet-isolated-process-guide?tabs=windows#aspnet-core-integration
Lo primero:
Añadir el paquete nuget:
```
 Microsoft.Azure.Functions.Worker.Extensions.Http.AspNetCore
```
Actualizar 
```
* Microsoft.Azure.Functions.Worker.Sdk
* Microsoft.Azure.Functions.Worker
```

Ya hay creada una clase Weather en el proyecto Model por el script de creación. Completamos o copiamos el código de este mismo repositorio y lo pegamos.

Abrimos la Función en el proyecto Api y aquí, extrañamente hay muchas cosas que cambiar dado que la plantilla que se crea está muy desactualiada. 
Recomiendo copiar los ficheros de este mismo proyecto para no teclear errores que puedan ser difíciles de detectar.
## En GetWeather.cs

'''
using Microsoft.AspNetCore.Http;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Logging;
using Model;
using Microsoft.AspNetCore.Mvc;

namespace Api {
    public class GetWeather {
        ILogger _logger;

        public GetWeather(ILogger<HttpTriggerCSharp> logger) {
            _logger = logger;
        }
        [Function("Weather")]
        public IActionResult Get([HttpTrigger(AuthorizationLevel.Anonymous, "get")] HttpRequest req) {
            _logger.LogInformation("Log desde la functión HttpTriggerCSharp");
            return new JsonResult(this.getlWheather());
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
```
Dejo comentado el código anterior de la plantilla para que se vean todos los cambios.

Yo diría, además de los using que lo más relevante es el cambio de los parámetros de la función. 
Ahora devuelve un IActionResult que es la respuesta que normalmente se usa en Asp.net core.

## en Program.cs hay que cambiar ConfigureFunctionsWorkerDefaults por ConfigureFunctionsWebApplication
```
using Microsoft.Extensions.Hosting;

var host = new HostBuilder()
    .ConfigureFunctionsWebApplication()
//    .ConfigureFunctionsWorkerDefaults()
    .Build();

host.Run();
```

## en Local.setting.json

Y por supuesto CORS.

```
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
```
