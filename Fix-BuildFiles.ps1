$root = Get-Location

# Overwrite IChatCompletionClient.cs
@'
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
'@ | Set-Content "$root\src\TEAI.Chatbot.Adapters.Llm\IChatCompletionClient.cs" -Encoding UTF8

# Overwrite HttpLangGraphClient.cs
@'
using System.Net.Http.Json;

namespace TEAI.Chatbot.Adapters.LangGraph;

public sealed class HttpLangGraphClient : ILangGraphClient
{
    private readonly HttpClient _client;
    private readonly string _endpoint;

    public HttpLangGraphClient(HttpClient client, string endpoint)
    {
        _client = client;
        _endpoint = endpoint;
    }

    public async Task<LangGraphResult> InvokeAsync(string flowName, string input, CancellationToken ct = default)
    {
        var payload = new { flow = flowName, text = input };
        var response = await _client.PostAsJsonAsync(_endpoint, payload, ct);
        response.EnsureSuccessStatusCode();
        var result = await response.Content.ReadFromJsonAsync<LangGraphResult>(cancellationToken: ct);
        return result ?? new LangGraphResult { Text = "[LangGraph] Empty result" };
    }
}
'@ | Set-Content "$root\src\TEAI.Chatbot.Adapters.LangGraph\HttpLangGraphClient.cs" -Encoding UTF8

