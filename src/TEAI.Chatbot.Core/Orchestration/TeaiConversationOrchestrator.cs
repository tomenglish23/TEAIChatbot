using TEAI.Chatbot.Core.Flows;
using TEAI.Chatbot.Core.Models;

namespace TEAI.Chatbot.Core.Orchestration;

public sealed class TeaiConversationOrchestrator : IConversationOrchestrator
{
    private readonly IFlowEngine _engine;

    public TeaiConversationOrchestrator(IFlowEngine engine)
    {
        _engine = engine;
    }

    public async Task<OutboundMessage> HandleAsync(NormalizedEvent ev, CancellationToken ct = default)
    {
        var flowName = "FB_DemoCommentFlow";
        var correlationId = $"{ev.PostId}:{ev.CommentId}";
        var ctx = new FlowContext(flowName, correlationId, ev);

        var result = await _engine.HandleAsync(ctx, ct);

        return new OutboundMessage
        {
            TargetChannel = "FacebookComments",
            RecipientId = ev.UserId,
            PostId = ev.PostId,
            CommentId = ev.CommentId,
            Text = result.Text
        };
    }
}
