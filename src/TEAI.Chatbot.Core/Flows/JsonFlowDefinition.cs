namespace TEAI.Chatbot.Core.Flows;

public sealed class JsonFlowDefinition
{
    public string Id { get; set; } = "";
    public string Name { get; set; } = "";
    public List<JsonFlowStep> Steps { get; set; } = new();
}

public sealed class JsonFlowStep
{
    public string Id { get; set; } = "";
    public string Type { get; set; } = "";
    public string? Prompt { get; set; }
}
