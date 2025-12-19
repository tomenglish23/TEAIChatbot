using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TEAI.Chatbot.Core.Ingress
{
    public interface IIngressDefaults
    {
        string SourceChannel { get; }
        bool TriggerMatchedByDefault { get; }
        DateTime UtcNow { get; }
    }
}
