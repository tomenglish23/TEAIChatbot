namespace TEAI.Chatbot.Core.Models;

public sealed class ChatResponse
{
    public string ReplyText { get; init; } = "";
    public string? DebugInfo { get; init; }
    public bool IsError { get; init; }
}
