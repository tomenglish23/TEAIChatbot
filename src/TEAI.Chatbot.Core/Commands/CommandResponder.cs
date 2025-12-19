using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TEAI.Chatbot.Core.Commands
{
    public sealed class CommandResponder : ICommandResponder
    {
        public bool TryGetReply(string input, out string reply)
        {
            reply = string.Empty;

            if (string.IsNullOrWhiteSpace(input))
                return false;

            var t = input.Trim().ToLowerInvariant();

            if (t == "!solid")
            {
                reply =
                    "SOLID principles:\n" +
                    "• Single Responsibility\n" +
                    "• Open/Closed\n" +
                    "• Liskov Substitution\n" +
                    "• Interface Segregation\n" +
                    "• Dependency Inversion";
                return true;
            }

            if (t == "!cicd")
            {
                reply =
                    "CI/CD overview:\n" +
                    "CI validates each commit via automated builds & tests.\n" +
                    "CD promotes validated builds through environments with gates.";
                return true;
            }

            if (t == "!sanity")
            {
                reply = $"[Sanity] Round-trip OK @ {DateTime.UtcNow:O}";
                return true;
            }

            if (t == "!chatbot")
            {
                reply = "\n\n\nTOM ENGLISH AI\n" +
"TEAIChatbot\n" +
"Distributed Chatbot Platform Architecture\n" +
"Serverless • Event-driven • Multi-channel • Conversion-focused\n" +
"TECHNICAL WHITEPAPER\n" +
"Tom English\n" +
"Senior Software Engineer • AI Architect\n" +
"TomEnglishAI.com\n" +
"LinkedIn.com/in/TomEnglishAI\n" +
"November, 2025\n" +
"\n" +
"SECTION 1 — User & Business Impact\n" +
"A chatbot only matters if it creates momentum. When I first tested systems like this, I realized how much a smooth UX shaped my decision-making — I felt guided, reassured & genuinely eager to buy. Good flow removes friction. It gives the user a sense of progress. That emotional lift is the real engine behind conversions.\n" +
"\n" +
"Businesses want that same effect on every visitor. A chatbot that doesn’t convert is a liability. Owners want a guided, persuasive conversation that hooks interest, keeps the user engaged & leads them toward a decision. TEAIChatbot was designed around that reality.\n" +
"\n" +
"This platform connects user emotion to business outcomes. It blends deterministic flow logic with the psychology that drives decisions: clarity, momentum & confidence. Users feel supported at every step. Businesses see higher conversions, fewer drop-offs & a predictable path from curiosity to commitment.\n" +
"\n" +
"The architecture is the foundation — but the value is human. TEAIChatbot guides like a salesperson, responds with expertise & maintains the conversation without pressure. The technology is complex, but the purpose is simple: better engagement, better decisions & better results.\n" +
"\n" +
"SECTION 2 — Introduction\n" +
"\n" +
"2.1 Executive Summary\n" +
"\n" +
"This architecture describes a modern, distributed chatbot system built for reliability, scale, & precision. All inbound messages enter through a secure branded endpoint, where an Azure Function authenticates the request, normalizes the payload, loads user context, retrieves the correct flow, or calls OpenAI when needed. Each execution is fully independent, allowing the system to scale automatically without carrying state in memory.\n" +
"\n" +
"Downstream components — flow definitions, storage, event triggers, business logic services, model calls, & outbound message dispatch — operate as loosely coupled parts. This creates a system that is predictable in structure yet flexible enough to extend: new triggers, new flows, new channels, or new logic can be added without rewriting the foundation.\n" +
"\n" +
"The architecture also supports automated sales flows. A single comment on a social platform can trigger a defined sequence that guides users through a conversation pipeline, captures intent, asks the right questions, & moves prospects toward a conversion moment. By externalizing state & centralizing orchestration, the platform behaves consistently across high volume, multiple channels, & evolving use cases.\n" +
"\n" +
"This establishes the core of the Tom English AI chatbot platform: a distributed, extensible system built to make decisions, preserve context, & deliver intelligent responses at scale.\n" +
"\n" +
"2.2 Detailed Introduction\n" +
"\n" +
"The modern chatbot is no longer a single program. It is a distributed system: messages originate on a social platform, travel across the internet, pass through orchestration logic in the cloud, & return as intelligent, stateful responses.  Each reply is the result of coordinated components rather than a single monolithic application.\n" +
"\n" +
"My turning point came when I followed a link sent by a chatbot that gradually pulled me into a guided experience. I was skeptical, but the interactions were persistent & well-crafted. Within days I had learned how effective a carefully designed flow can be. One example showed a creator posting videos of herself wearing a dress & instructing viewers to comment “I love this dress.” That comment triggered a full sales flow. The chatbot asked simple questions, kept the conversation moving, & guided potential buyers until they pressed “Purchase.”\n" +
"\n" +
"The experience reframed how I thought about chatbots. They are not just passive responders. They are orchestrators of a conversation pipeline:\n" +
"\n" +
"a social trigger ? a captured moment of interest ? a structured set of replies ? a conversion opportunity.\n" +
"\n" +
"A key realization was that api.tomenglishai.com is not where the logic lives. It is only the branded entry point. The true processing — authentication, payload normalization, routing, state loading, OpenAI fallback calls, business logic, & message dispatch — happens inside an Azure Function where each request runs independently & scales automatically. The system stays stateless by storing user context externally, allowing conversations to continue naturally across multiple messages.\n" +
"\n";
                return true;
            }

            return false;
        }
    }
}
