using TEAI.Chatbot.Core.Flows;

namespace TEAI.Chatbot.Core.Flows;

public sealed class StubFlowEngine : IFlowEngine
{
    public Task<FlowResult> HandleAsync(FlowContext ctx, CancellationToken ct = default)
    {
        var reply = $"[StubFlowEngine] Flow {ctx.FlowName} handled text: \"{ctx.Event.OriginalText}\"";
        return Task.FromResult(new FlowResult
        {
            Success = true,
            Text = reply
        });
    }
}
