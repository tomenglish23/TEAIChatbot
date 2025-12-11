using TEAI.Chatbot.Core.Models;

namespace TEAI.Chatbot.Storage.Abstractions;

public interface IOwnerConfigStore
{
    Task<OwnerConfig?> GetAsync(string ownerId, CancellationToken ct = default);
    Task SaveAsync(OwnerConfig config, CancellationToken ct = default);
}
