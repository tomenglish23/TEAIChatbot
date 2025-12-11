using System.Text.Json;
using TEAI.Chatbot.Core.Models;
using TEAI.Chatbot.Storage.Abstractions;

namespace TEAI.Chatbot.Storage.FileSystem;

public sealed class FileOwnerConfigStore : IOwnerConfigStore
{
    private readonly string _root;

    public FileOwnerConfigStore(string? root = null)
    {
        _root = root ?? Path.Combine(AppContext.BaseDirectory, "data", "owners");
    }

    public async Task<OwnerConfig?> GetAsync(string ownerId, CancellationToken ct = default)
    {
        var path = Path.Combine(_root, $"{ownerId}.json");
        if (!File.Exists(path)) return null;

        var json = await File.ReadAllTextAsync(path, ct);
        return JsonSerializer.Deserialize<OwnerConfig>(json);
    }

    public async Task SaveAsync(OwnerConfig config, CancellationToken ct = default)
    {
        Directory.CreateDirectory(_root);
        var path = Path.Combine(_root, $"{config.OwnerId}.json");
        var json = JsonSerializer.Serialize(config, new JsonSerializerOptions { WriteIndented = true });
        await File.WriteAllTextAsync(path, json, ct);
    }
}
