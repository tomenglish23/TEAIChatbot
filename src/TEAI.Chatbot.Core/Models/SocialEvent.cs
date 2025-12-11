namespace TEAI.Chatbot.Core.Models;

public sealed class SocialEvent
{
    public string Platform { get; init; } = "";
    public string PageId { get; init; } = "";
    public string PostId { get; init; } = "";
    public string CommentId { get; init; } = "";
    public string AuthorName { get; init; } = "";
    public string AuthorId { get; init; } = "";
    public string Text { get; init; } = "";
    public DateTimeOffset CreatedUtc { get; init; }
    public string ThreadKey { get; init; } = "";
    public IReadOnlyList<string> TriggerPhrases { get; init; } = Array.Empty<string>();
}
