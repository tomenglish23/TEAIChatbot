namespace TEAI.Chatbot.Adapters.LangGraph;

public interface ILangGraphClient
{
    Task<LangGraphResult> InvokeAsync(string flowName, string input, CancellationToken ct = default);
}
