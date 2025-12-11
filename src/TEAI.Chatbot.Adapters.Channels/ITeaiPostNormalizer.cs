using TEAI.Chatbot.Core.Models;

namespace TEAI.Chatbot.Adapters.Channels;

public interface ITeaiPostNormalizer
{
    NormalizedEvent Normalize(TeaiPostMessageDto dto);
}
