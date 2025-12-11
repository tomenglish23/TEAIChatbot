using TEAI.Chatbot.Core.Models;

namespace TEAI.Chatbot.Core.Flows;

public sealed class FlowContext
{
    public string FlowName { get; }
    public string CorrelationId { get; }
    public NormalizedEvent Event { get; }

    public FlowContext(string flowName, string correlationId, NormalizedEvent ev)
    {
        FlowName = flowName;
        CorrelationId = correlationId;
        Event = ev;
    }
}
