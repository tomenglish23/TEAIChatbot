namespace TEAI.Chatbot.Core.Models;

public sealed class TriggerRule
{
    public string Id { get; init; } = "";
    public string Description { get; init; } = "";
    public IReadOnlyList<string> Phrases { get; init; } = Array.Empty<string>();
    public string FlowId { get; init; } = "";
}
