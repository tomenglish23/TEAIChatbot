using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using TEAI.Chatbot.Adapters.Channels;
using TEAI.Chatbot.Adapters.Llm;
using TEAI.Chatbot.Core.Flows;
using TEAI.Chatbot.Core.Models;
using TEAI.Chatbot.Core.Orchestration;
using TEAI.Chatbot.Storage.Abstractions;
using TEAI.Chatbot.Storage.FileSystem;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddHttpClient();
builder.Services.AddScoped<IChatCompletionClient, StubChatCompletionClient>();
builder.Services.AddScoped<IFlowEngine, JsonFlowEngine>();
builder.Services.AddScoped<IConversationOrchestrator, TeaiConversationOrchestrator>();
builder.Services.AddScoped<ITeaiPostNormalizer, TeaiPostNormalizer>();
builder.Services.AddSingleton<IFlowDefinitionStore, FileFlowDefinitionStore>();
builder.Services.AddSingleton<IOwnerConfigStore, FileOwnerConfigStore>();

var app = builder.Build();

app.MapPost("/ingress", async (
    NormalizedEvent ev,
    IConversationOrchestrator orchestrator,
    CancellationToken ct) =>
{
    var outbound = await orchestrator.HandleAsync(ev, ct);
    return Results.Ok(outbound);
});

app.Run();
