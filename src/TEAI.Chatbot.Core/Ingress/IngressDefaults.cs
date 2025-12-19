using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TEAI.Chatbot.Core.Ingress
{
    public sealed class IngressDefaults : IIngressDefaults
    {
        public string SourceChannel => "TeaiWebsite";
        public bool TriggerMatchedByDefault => true;
        public DateTime UtcNow => DateTime.UtcNow;
    }
}
