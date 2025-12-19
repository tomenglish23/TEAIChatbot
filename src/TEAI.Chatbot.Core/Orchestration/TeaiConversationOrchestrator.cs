using TEAI.Chatbot.Core.Commands;
using TEAI.Chatbot.Core.Flows;
using TEAI.Chatbot.Core.Models;

namespace TEAI.Chatbot.Core.Orchestration;

public sealed class TeaiConversationOrchestrator : IConversationOrchestrator
{
    private readonly IFlowEngine _engine;
    private readonly ICommandResponder _commandResponder;

    public TeaiConversationOrchestrator(IFlowEngine engine,
                                        ICommandResponder commandResponder)
    {
        _engine = engine;
        _commandResponder = commandResponder;
    }

    public async Task<OutboundMessage> HandleAsync(
        NormalizedEvent ev,
        CancellationToken ct = default)
    {
        var flowName = "FB_DemoCommentFlow";
        var correlationId = $"{ev.PostId}:{ev.CommentId}";
        var ctx = new FlowContext(flowName, correlationId, ev);

        // ✅ COMMAND SHORT-CIRCUIT
        if (_commandResponder.TryGetReply(ev.OriginalText, out var reply))
        {
            return new OutboundMessage
            {
                TargetChannel = "FacebookComments1",
                RecipientId = ev.UserId,
                PostId = ev.PostId,
                CommentId = ev.CommentId,
                Text = reply
            };
        }

        // ✅ FALL THROUGH TO FLOW ENGINE
        var result = await _engine.HandleAsync(ctx, ct);

        return new OutboundMessage
        {
            TargetChannel = "FacebookComments1",
            RecipientId = ev.UserId,
            PostId = ev.PostId,
            CommentId = ev.CommentId,
            Text = result.Text
        };
    }
}
