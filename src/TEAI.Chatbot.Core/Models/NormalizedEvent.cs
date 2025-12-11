namespace TEAI.Chatbot.Core.Models;

public sealed class NormalizedEvent
{
    public string SourceChannel { get; set; } = "";
    public string UserId { get; set; } = "";
    public string PostId { get; set; } = "";
    public string CommentId { get; set; } = "";
    public string OriginalText { get; set; } = "";
    public bool TriggerMatched { get; set; }
    public DateTime CreatedUtc { get; set; }
}
