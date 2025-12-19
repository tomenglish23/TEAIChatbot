namespace TEAI.Chatbot.Adapters.Channels;

public sealed class TeaiPostMessageDto
{
    public string? PostId { get; set; }
    public string? CommentId { get; set; }
    public string? Text { get; set; }
    public string? PageId { get; set; }
    public string? UserId { get; set; }

    // optional, non-breaking
    public string? SourceChannel { get; set; }  // "TeaiWebsite", "Facebook", "LinkedIn", etc
    public DateTime? CreatedUtc { get; set; }   // allow caller to supply
}
