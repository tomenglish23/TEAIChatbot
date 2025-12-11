using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using System.Threading;
using System.Threading.Tasks;
using TeaiChatbotDemo.Api.Ai;
using TeaiChatbotDemo.Api.Domain;
using TeaiChatbotDemo.Api.Ingress;

var builder = WebApplication.CreateBuilder(args);

// DI wiring
builder.Services.AddSingleton<IOpenAiChatClient, StubOpenAiChatClient>();
builder.Services.AddScoped<IngressHandler>();

var app = builder.Build();

app.MapGet("/", () => "TEAIChatbot demo ingress running");

// Endpoint that FakeSocialEventRunner.ps1 calls
app.MapPost("/ingress", async (NormalizedEvent ev, IngressHandler handler, CancellationToken ct) =>
{
    var outbound = await handler.HandleAsync(ev, ct);
    return Results.Json(outbound);
});

app.Run();
