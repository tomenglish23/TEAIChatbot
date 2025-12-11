namespace TEAI.Chatbot.Adapters.Llm;

public sealed class ChatCompletionResult
{
    public string Text { get; set; } = "";
    public string? Diagnostic { get; set; }
}

public interface IChatCompletionClient
{
    Task<ChatCompletionResult> GetCompletionAsync(string prompt, CancellationToken ct = default);
}
