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
