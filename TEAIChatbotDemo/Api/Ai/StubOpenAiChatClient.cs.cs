using System.Threading;
using System.Threading.Tasks;
using TeaiChatbotDemo.Api.Domain;

namespace TeaiChatbotDemo.Api.Ai;

public interface IOpenAiChatClient
{
    Task<FlowResult> GetReplyAsync(FlowContext ctx, CancellationToken ct = default);
}

public sealed class StubOpenAiChatClient : IOpenAiChatClient
{
    public Task<FlowResult> GetReplyAsync(FlowContext ctx, CancellationToken ct = default)
    {
        var ev = ctx.Event;

        var text =
            "Thanks for trying the TEAIChatbot demo. " +
            $"I saw your comment \"{ev.OriginalText}\" " +
            "on my TEAI post " +
            "routed it through a small demo flow " +
            "then sent this reply back through my local chatbot slice.";

        var result = new FlowResult
        {
            Success = true,
            Text = text
        };

        return Task.FromResult(result);
    }
}
