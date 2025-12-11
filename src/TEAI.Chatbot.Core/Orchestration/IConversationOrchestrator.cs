using TEAI.Chatbot.Core.Models;
using TEAI.Chatbot.Core.Flows;

namespace TEAI.Chatbot.Core.Orchestration;

public interface IConversationOrchestrator
{
    Task<OutboundMessage> HandleAsync(NormalizedEvent ev, CancellationToken ct = default);
}
