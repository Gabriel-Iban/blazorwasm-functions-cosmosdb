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
