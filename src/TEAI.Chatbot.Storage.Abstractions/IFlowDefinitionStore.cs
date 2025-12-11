using TEAI.Chatbot.Core.Flows;

namespace TEAI.Chatbot.Storage.Abstractions;

public interface IFlowDefinitionStore
{
    Task<JsonFlowDefinition?> GetAsync(string id, CancellationToken ct = default);
    Task SaveAsync(JsonFlowDefinition definition, CancellationToken ct = default);
}
