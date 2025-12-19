TEAIChatbot is a distributed, event-driven chatbot system built to demonstrate how a production-grade AI-driven workflow behaves end-to-end. The architecture supports social-media ingestion, flow-engine decision logic, language-model adapters, owner-defined configuration, & outbound publishing to multiple channels.

This repository contains the first validated slice of the full architecture:
Comment ? Ingress API ? Normalization ? Orchestrator ? Flow Engine ? LLM Adapter (stub) ? Outbound Message
All of this is functioning locally using a PowerShell harness.

Current Working Slice

The following round-trip is fully operational:

A simulated social-media comment is posted via FakeSocialEventRunner.ps1

The Ingress API receives the event at /ingress

The comment is normalized into a channel-independent event

The Conversation Orchestrator selects a flow

The Flow Engine executes a JSON-based flow definition

The LLM Adapter returns a stubbed response

The system emits an OutboundMessage formatted for a specific channel

Confirmed working output example:

{
  "targetChannel": "FacebookComments",
  "recipientId": "USER_001",
  "postId": "POST_001",
  "commentId": "CMT_001",
  "text": "[Stub LLM] This is a demo reply based on your comment."
}


This validates the architectural spine & confirms that DI, flow engine boundaries, orchestrator logic, & adapter interfaces are correct.

Repository Structure
src/
  TEAI.Chatbot.Core/                     # Flow engine, models, orchestrator
  TEAI.Chatbot.Storage.Abstractions/     # Interfaces: flow store, owner config
  TEAI.Chatbot.Storage.FileSystem/       # JSON-based storage implementation
  TEAI.Chatbot.Adapters.Channels/        # Normalizers for incoming events
  TEAI.Chatbot.Adapters.Llm/             # Stub + interface for chat completion
  TEAI.Chatbot.Adapters.LangGraph/       # HTTP-based LangGraph adapter (stub)
  TEAI.Chatbot.Ingress.Api/              # Minimal API endpoint for /ingress
  TEAI.Chatbot.Owner.Api/                # CRUD for flows and owner config
  TEAI.Chatbot.Ingress.Functions/        # Placeholder for Azure Functions ingress

tests/
  TEAI.Chatbot.Core.Tests/
  TEAI.Chatbot.Ingress.Tests/
  TEAI.Chatbot.Owner.Tests/

tools/
  FakeSocialEventRunner.ps1              # Local demo harness (? Ingress API)

*.sln                                     # Server, Azure, Tests, Client solutions

How to Run the Working System
1. Start the Ingress API
dotnet run --project .\src\TEAI.Chatbot.Ingress.Api\TEAI.Chatbot.Ingress.Api.csproj


Console output:

Now listening on: http://localhost:5193
Application started. Press Ctrl+C to shut down.


Keep this window open.

2. Run the Harness in a Second Window
pwsh .\tools\FakeSocialEventRunner.ps1 -IngressUrl "http://localhost:5193/ingress"


Expected result: JSON outbound message printed to console.

Architecture Overview (Slice-Level)
Ingress

Receives comments/posts from external channels. Normalizes incoming data (UserId, CommentId, PostId, text). The goal is to isolate the system from platform specifics (FB, Reddit, IG, etc.).

Flow Engine

Executes a JSON-based flow definition describing how to respond:

Trigger detection

Prompt assembly

Branching

LLM invocation

Output transformation

Current state uses a stub LLM to avoid external dependencies.

Orchestrator

Coordinates normalization ? flow selection ? execution ? outbound response assembly.

Adapters

Well-defined interface layer so the system can plug into:

Languages models (OpenAI, Azure OpenAI, LangGraph)

Messaging channels

Storage implementations

Owner API

Allows chatbot owners to configure:

Trigger phrases

Flow definitions

Response templates

This is scaffolded & will be filled out in the next slice.

Next Milestones

These will extend the working slice:

Flow Storage (CRUD)
Owner API persists JSON flows & owner configs, enabling real system customization.

LLM Adapter Integration (real model)
Swap StubChatCompletionClient with a DI-bound real adapter.

Azure Functions Ingress
Cloud ingress for production fan-out & distributed event routing.

Outbound Publisher
Push back to FB/IG/Twitter/Reddit depending on channel.

Client UI (React)
Owner dashboard: triggers, flows, test messages, logs.

Why This Architecture

This structure mirrors how modern production chatbots operate inside enterprises:

Event-driven ingestion

Strict normalization

Declarative flow logic

Swappable LLM backends

Owner-configurable behavior

Outbound fan-out

Cloud-friendly (Functions, queues, storage)

The first slice confirms that all these abstractions can hang together cleanly.

Status

Working, validated first slice.
System is ready for:

Owner API fleshing

Flow storage

LangGraph or OpenAI adapters

CI/CD pipeline

Integration tests
