using TEAI.Chatbot.Core.Models;
using TEAI.Chatbot.Core.Orchestration;

namespace TEAI.Chatbot.Ingress.Api
{
    // IngressEndpoints.cs
    public static class IngressEndpoints
    {
        public static IEndpointRouteBuilder MapIngressEndpoints(this IEndpointRouteBuilder app)
        {
            app.MapPost("/ingress", async (
                NormalizedEvent ev,
                IConversationOrchestrator orchestrator,
                CancellationToken ct) =>
            {
                // 1) read body
                // 2) deserialize into req
                // else fall through to flow + LLM path
                // 3) do work
                var outbound = await orchestrator.HandleAsync(ev, ct);
                return Results.Ok(outbound);
            }).RequireCors("LocalDev");

            app.MapPost("/ingress/events", (NormalizedEvent ev) => Results.Ok(new { ok = true }))
                .RequireCors("LocalDev");

            return app;
        }
    }
}
