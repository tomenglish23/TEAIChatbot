using TEAI.Chatbot.Core.Models;
using TEAI.Chatbot.Core.Flows;
using TEAI.Chatbot.Adapters.Llm;

namespace TEAI.Chatbot.Core.Flows;

public sealed class JsonFlowEngine : IFlowEngine
{
    private readonly IChatCompletionClient _llm;

    public JsonFlowEngine(IChatCompletionClient llm)
    {
        _llm = llm;
    }

    public async Task<FlowResult> HandleAsync(FlowContext ctx, CancellationToken ct = default)
    {
        var prompt = $"Flow={ctx.FlowName} Text=\"{ctx.Event.OriginalText}\"";
        var llmResult = await _llm.GetCompletionAsync(prompt, ct);
        return new FlowResult { Success = true, Text = llmResult.Text, Diagnostic = llmResult.Diagnostic };
    }
}
