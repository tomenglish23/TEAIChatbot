using TEAI.Chatbot.Core.Flows;

namespace TEAI.Chatbot.Core.Flows;

public interface IFlowEngine
{
    Task<FlowResult> HandleAsync(FlowContext ctx, CancellationToken ct = default);
}
