namespace TeaiChatbotDemo.Api.Domain;

public sealed class OutboundMessage
{
    public string TargetChannel { get; set; } = "";
    public string RecipientId   { get; set; } = "";
    public string PostId        { get; set; } = "";
    public string CommentId     { get; set; } = "";
    public string Text          { get; set; } = "";
}
