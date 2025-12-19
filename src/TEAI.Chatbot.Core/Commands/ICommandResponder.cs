using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TEAI.Chatbot.Core.Commands
{
    public interface ICommandResponder
    {
        bool TryGetReply(string input, out string reply);
    }
}
