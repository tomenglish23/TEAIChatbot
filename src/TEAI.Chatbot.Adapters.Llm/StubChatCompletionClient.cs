namespace TEAI.Chatbot.Adapters.Llm;

public sealed class StubChatCompletionClient : IChatCompletionClient
{
    public Task<ChatCompletionResult> GetCompletionAsync(string prompt, CancellationToken ct = default)
    {
        var result = new ChatCompletionResult
        {
            Text = "[Stub LLM] This is a demo reply based on your comment.",
            Diagnostic = "StubChatCompletionClient"
        };

        return Task.FromResult(result);
    }
}
