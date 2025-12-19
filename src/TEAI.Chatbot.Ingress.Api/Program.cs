// using Microsoft.AspNetCore.Builder;
// using Microsoft.Extensions.DependencyInjection;
// using Microsoft.Extensions.Hosting;
using TEAI.Chatbot.Adapters.Channels;
using TEAI.Chatbot.Adapters.Llm;
using TEAI.Chatbot.Core.Commands;
using TEAI.Chatbot.Core.Flows;
// using TEAI.Chatbot.Core.Models;
using TEAI.Chatbot.Core.Orchestration;
using TEAI.Chatbot.Storage.Abstractions;
using TEAI.Chatbot.Storage.FileSystem;
// using Microsoft.AspNetCore.Routing;
// using Microsoft.AspNetCore.Routing.Patterns;
using TEAI.Chatbot.Ingress.Api;
using TEAI.Chatbot.Core.Ingress;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddHttpClient();
builder.Services.AddSingleton<ICommandResponder, CommandResponder>();
builder.Services.AddScoped<IChatCompletionClient, StubChatCompletionClient>();
builder.Services.AddScoped<IFlowEngine, JsonFlowEngine>();
builder.Services.AddScoped<IConversationOrchestrator, TeaiConversationOrchestrator>();
builder.Services.AddScoped<ITeaiPostNormalizer, TeaiPostNormalizer>();
builder.Services.AddSingleton<IFlowDefinitionStore, FileFlowDefinitionStore>();
builder.Services.AddSingleton<IOwnerConfigStore, FileOwnerConfigStore>();
builder.Services.AddSingleton<IIngressDefaults, IngressDefaults>();

builder.Services.AddCors(options =>
{
    options.AddPolicy("LocalDev", policy =>
        policy.WithOrigins("http://localhost:3000")
              .AllowAnyHeader()
              .AllowAnyMethod()
    );
});

var app = builder.Build();

app.UseCors("LocalDev");

// ===
// === Add Endpoints
// ===

app.MapGet("/routes", (IEnumerable<EndpointDataSource> sources) =>
{
var routes = sources
    .SelectMany(s => s.Endpoints)
    .OfType<RouteEndpoint>()
    .Select(e =>
    {
        var methods = e.Metadata
            .OfType<HttpMethodMetadata>()
            .FirstOrDefault()?.HttpMethods;

        return new
        {
            Route = e.RoutePattern.RawText,
            Methods = methods is null ? Array.Empty<string>() : methods.ToArray()
        };
    })
    .OrderBy(x => x.Route);

return Results.Ok(routes);
});

app.MapGet("/", () =>
{
    return Results.Ok(new
    {
        status = "running",
        domain = "api.tomenglishai.com",
        service = "teai-platform-api"
    });
});

// simple health check, if you don't already have one
app.MapGet("/health", () => Results.Ok(new { status = "healthy" }));

app.MapIngressEndpoints(); // <-- must be called

app.Run();
