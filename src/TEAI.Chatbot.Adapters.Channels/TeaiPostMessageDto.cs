namespace TEAI.Chatbot.Adapters.Channels;

public sealed class TeaiPostMessageDto
{
    public string? PostId { get; set; }
    public string? CommentId { get; set; }
    public string? Text { get; set; }
    public string? PageId { get; set; }
    public string? UserId { get; set; }
}
