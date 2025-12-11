using TEAI.Chatbot.Core.Models;

namespace TEAI.Chatbot.Adapters.Channels;

public sealed class TeaiPostNormalizer : ITeaiPostNormalizer
{
    public NormalizedEvent Normalize(TeaiPostMessageDto dto)
    {
        return new NormalizedEvent
        {
            SourceChannel = "TeaiWebsite",
            UserId = dto.UserId ?? "",
            PostId = dto.PostId ?? "",
            CommentId = dto.CommentId ?? "",
            OriginalText = dto.Text ?? "",
            TriggerMatched = true,
            CreatedUtc = DateTime.UtcNow
        };
    }
}
