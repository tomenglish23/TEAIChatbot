using System.Text.Json;
using TEAI.Chatbot.Core.Flows;
using TEAI.Chatbot.Storage.Abstractions;

namespace TEAI.Chatbot.Storage.FileSystem;

public sealed class FileFlowDefinitionStore : IFlowDefinitionStore
{
    private readonly string _root;

    public FileFlowDefinitionStore(string? root = null)
    {
        _root = root ?? Path.Combine(AppContext.BaseDirectory, "data", "flows");
    }

    public async Task<JsonFlowDefinition?> GetAsync(string id, CancellationToken ct = default)
    {
        var path = Path.Combine(_root, $"{id}.json");
        if (!File.Exists(path)) return null;

        var json = await File.ReadAllTextAsync(path, ct);
        return JsonSerializer.Deserialize<JsonFlowDefinition>(json);
    }

    public async Task SaveAsync(JsonFlowDefinition definition, CancellationToken ct = default)
    {
        Directory.CreateDirectory(_root);
        var path = Path.Combine(_root, $"{definition.Id}.json");
        var json = JsonSerializer.Serialize(definition, new JsonSerializerOptions { WriteIndented = true });
        await File.WriteAllTextAsync(path, json, ct);
    }
}
