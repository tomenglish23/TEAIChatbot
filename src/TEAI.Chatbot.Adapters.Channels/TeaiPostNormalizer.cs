using TEAI.Chatbot.Core.Models;
using TEAI.Chatbot.Core.Ingress;

namespace TEAI.Chatbot.Adapters.Channels;

public sealed class TeaiPostNormalizer : ITeaiPostNormalizer
{
    private readonly IIngressDefaults _defaults;

    public TeaiPostNormalizer(IIngressDefaults defaults)
    {
        _defaults = defaults;
    }

    public NormalizedEvent Normalize(TeaiPostMessageDto dto)
    {
        var created = dto.CreatedUtc ?? _defaults.UtcNow;

        return new NormalizedEvent
        {
            SourceChannel = _defaults.SourceChannel,
            UserId = dto.UserId ?? "",
            PostId = dto.PostId ?? "",
            CommentId = dto.CommentId ?? "",
            OriginalText = dto.Text ?? "",
            TriggerMatched = _defaults.TriggerMatchedByDefault,
            CreatedUtc = created
        };
    }
}

