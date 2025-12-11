namespace TEAI.Chatbot.Core.Models;

public sealed class OwnerConfig
{
    public string OwnerId { get; set; } = "";
    public string PageId { get; set; } = "";
    public string PageAccessToken { get; set; } = "";
    public string[] TriggerPhrases { get; set; } = Array.Empty<string>();
}
