namespace TEAI.Chatbot.Core.Flows;

public sealed class FlowResult
{
    public bool Success { get; set; }
    public string Text { get; set; } = "";
    public string? Diagnostic { get; set; }
}
