using System;
using System.Threading;
using System.Threading.Tasks;
using TeaiChatbotDemo.Api.Ai;
using TeaiChatbotDemo.Api.Domain;

namespace TeaiChatbotDemo.Api.Ingress;

public sealed class IngressHandler
{
    private readonly IOpenAiChatClient _chatClient;

    public IngressHandler(IOpenAiChatClient chatClient)
    {
        _chatClient = chatClient;
    }

    public async Task<OutboundMessage> HandleAsync(NormalizedEvent ev, CancellationToken ct = default)
    {
        var flowName = "FB_DemoCommentFlow";
        var correlationId = $"{ev.PostId}:{ev.CommentId}";

        Console.WriteLine($"[Ingress] Event from {ev.SourceChannel} user {ev.UserId} post {ev.PostId} comment {ev.CommentId}");
        Console.WriteLine($"[Ingress] Text: {ev.OriginalText}");

        var ctx = new FlowContext(flowName, correlationId, ev);

        var aiResult = await _chatClient.GetReplyAsync(ctx, ct);

        if (!aiResult.Success)
        {
            Console.WriteLine($"[Ingress] AI failure: {aiResult.Diagnostic}");
        }

        var outbound = new OutboundMessage
        {
            TargetChannel = "FacebookMessenger",
            RecipientId   = ev.UserId,
            PostId        = ev.PostId,
            CommentId     = ev.CommentId,
            Text          = aiResult.Text
        };

        Console.WriteLine($"[Ingress] Outbound text: {outbound.Text}");

        return outbound;
    }
}
