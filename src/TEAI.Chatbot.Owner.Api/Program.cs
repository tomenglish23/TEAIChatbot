using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using TEAI.Chatbot.Core.Flows;
using TEAI.Chatbot.Storage.Abstractions;
using TEAI.Chatbot.Storage.FileSystem;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddSingleton<IFlowDefinitionStore, FileFlowDefinitionStore>();
builder.Services.AddSingleton<IOwnerConfigStore, FileOwnerConfigStore>();

var app = builder.Build();

app.MapGet("/flows/{id}", async (string id, IFlowDefinitionStore store, CancellationToken ct) =>
{
    var def = await store.GetAsync(id, ct);
    return def is null ? Results.NotFound() : Results.Ok(def);
});

app.MapPost("/flows/{id}", async (string id, JsonFlowDefinition def, IFlowDefinitionStore store, CancellationToken ct) =>
{
    def.Id = id;
    await store.SaveAsync(def, ct);
    return Results.Ok();
});

app.Run();
