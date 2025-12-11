param(
    [string]$Root = (Get-Location).Path
)

Write-Host "Root: $Root"
Set-Location $Root

# ---------- helpers ----------

function Ensure-Dir {
    param([string]$Path)
    if (-not (Test-Path $Path)) {
        New-Item -ItemType Directory -Path $Path | Out-Null
        Write-Host "Created dir: $Path"
    }
}

function Remove-IfExists {
    param([string]$Path)
    if (Test-Path $Path) {
        Remove-Item -Path $Path -Force
        Write-Host "Removed: $Path"
    }
}

function New-ClassLibIfMissing {
    param(
        [string]$ProjectName,
        [string]$RelativeDir
    )

    $projDir  = Join-Path $Root $RelativeDir
    $projPath = Join-Path $projDir "$ProjectName.csproj"

    if (Test-Path $projPath) {
        Write-Host "Project exists, skipping: $projPath"
        return
    }

    Ensure-Dir $RelativeDir
    Write-Host "Creating classlib: $ProjectName at $RelativeDir"
    dotnet new classlib -n $ProjectName -o $RelativeDir
}

function New-WebIfMissing {
    param(
        [string]$ProjectName,
        [string]$RelativeDir
    )

    $projDir  = Join-Path $Root $RelativeDir
    $projPath = Join-Path $projDir "$ProjectName.csproj"

    if (Test-Path $projPath) {
        Write-Host "Web project exists, skipping: $projPath"
        return
    }

    Ensure-Dir $RelativeDir
    Write-Host "Creating minimal web project: $ProjectName at $RelativeDir"
    dotnet new web -n $ProjectName -o $RelativeDir
}

function New-TestProjIfMissing {
    param(
        [string]$ProjectName,
        [string]$RelativeDir
    )

    $projDir  = Join-Path $Root $RelativeDir
    $projPath = Join-Path $projDir "$ProjectName.csproj"

    if (Test-Path $projPath) {
        Write-Host "Test project exists, skipping: $projPath"
        return
    }

    Ensure-Dir $RelativeDir
    Write-Host "Creating xUnit test project: $ProjectName at $RelativeDir"
    dotnet new xunit -n $ProjectName -o $RelativeDir
}

function New-SlnIfMissing {
    param(
        [string]$SlnName
    )

    $slnPath = Join-Path $Root "$SlnName.sln"
    if (Test-Path $slnPath) {
        Write-Host "Solution exists, skipping: $slnPath"
        return
    }

    Write-Host "Creating solution: $SlnName"
    dotnet new sln -n $SlnName
}

function Add-ToSlnIfMissing {
    param(
        [string]$SlnName,
        [string]$ProjRelativePath
    )

    $slnPath  = Join-Path $Root "$SlnName.sln"
    $projPath = Join-Path $Root $ProjRelativePath

    if (-not (Test-Path $slnPath)) {
        Write-Host "Solution $SlnName.sln not found, skipping add of $ProjRelativePath"
        return
    }
    if (-not (Test-Path $projPath)) {
        Write-Host "Project $ProjRelativePath not found, skipping for $SlnName"
        return
    }

    Write-Host "Adding $ProjRelativePath to $SlnName.sln"
    dotnet sln "$SlnName.sln" add $ProjRelativePath
}

# ---------- base dirs ----------

Ensure-Dir "src"
Ensure-Dir "tests"
Ensure-Dir "tools"
Ensure-Dir "ui"

# ---------- projects from spec ----------

New-ClassLibIfMissing -ProjectName "TEAI.Chatbot.Core"                 -RelativeDir "src\TEAI.Chatbot.Core"
New-ClassLibIfMissing -ProjectName "TEAI.Chatbot.Storage.Abstractions" -RelativeDir "src\TEAI.Chatbot.Storage.Abstractions"
New-ClassLibIfMissing -ProjectName "TEAI.Chatbot.Storage.FileSystem"   -RelativeDir "src\TEAI.Chatbot.Storage.FileSystem"
New-ClassLibIfMissing -ProjectName "TEAI.Chatbot.Adapters.Channels"    -RelativeDir "src\TEAI.Chatbot.Adapters.Channels"
New-ClassLibIfMissing -ProjectName "TEAI.Chatbot.Adapters.Llm"         -RelativeDir "src\TEAI.Chatbot.Adapters.Llm"
New-ClassLibIfMissing -ProjectName "TEAI.Chatbot.Adapters.LangGraph"   -RelativeDir "src\TEAI.Chatbot.Adapters.LangGraph"

New-WebIfMissing -ProjectName "TEAI.Chatbot.Ingress.Api" -RelativeDir "src\TEAI.Chatbot.Ingress.Api"
New-WebIfMissing -ProjectName "TEAI.Chatbot.Owner.Api"   -RelativeDir "src\TEAI.Chatbot.Owner.Api"

New-ClassLibIfMissing -ProjectName "TEAI.Chatbot.Ingress.Functions" -RelativeDir "src\TEAI.Chatbot.Ingress.Functions"

New-TestProjIfMissing -ProjectName "TEAI.Chatbot.Core.Tests"    -RelativeDir "tests\TEAI.Chatbot.Core.Tests"
New-TestProjIfMissing -ProjectName "TEAI.Chatbot.Ingress.Tests" -RelativeDir "tests\TEAI.Chatbot.Ingress.Tests"
New-TestProjIfMissing -ProjectName "TEAI.Chatbot.Owner.Tests"   -RelativeDir "tests\TEAI.Chatbot.Owner.Tests"

# ---------- clean default Class1 files ----------

$defaultFiles = @(
    "src\TEAI.Chatbot.Core\Class1.cs",
    "src\TEAI.Chatbot.Storage.Abstractions\Class1.cs",
    "src\TEAI.Chatbot.Storage.FileSystem\Class1.cs",
    "src\TEAI.Chatbot.Adapters.Channels\Class1.cs",
    "src\TEAI.Chatbot.Adapters.Llm\Class1.cs",
    "src\TEAI.Chatbot.Adapters.LangGraph\Class1.cs",
    "src\TEAI.Chatbot.Ingress.Api\Program.cs",
    "src\TEAI.Chatbot.Ingress.Api\Startup.cs",
    "src\TEAI.Chatbot.Owner.Api\Program.cs",
    "src\TEAI.Chatbot.Owner.Api\Startup.cs",
    "src\TEAI.Chatbot.Ingress.Functions\Class1.cs"
)

foreach ($f in $defaultFiles) {
    $full = Join-Path $Root $f
    if (Test-Path $full) {
        Remove-Item $full -Force
        Write-Host "Removed template file: $f"
    }
}

# ---------- create core folders & files ----------

# TEAI.Chatbot.Core

Ensure-Dir "src\TEAI.Chatbot.Core\Models"
Ensure-Dir "src\TEAI.Chatbot.Core\Flows"
Ensure-Dir "src\TEAI.Chatbot.Core\Orchestration"

$coreModelsDir = "src\TEAI.Chatbot.Core\Models"
$coreFlowsDir  = "src\TEAI.Chatbot.Core\Flows"
$coreOrchDir   = "src\TEAI.Chatbot.Core\Orchestration"

@'
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
'@ | Set-Content "$coreModelsDir\SocialEvent.cs" -Encoding UTF8

@'
namespace TEAI.Chatbot.Core.Models;

public sealed class ChatResponse
{
    public string ReplyText { get; init; } = "";
    public string? DebugInfo { get; init; }
    public bool IsError { get; init; }
}
'@ | Set-Content "$coreModelsDir\ChatResponse.cs" -Encoding UTF8

@'
namespace TEAI.Chatbot.Core.Models;

public sealed class TriggerRule
{
    public string Id { get; init; } = "";
    public string Description { get; init; } = "";
    public IReadOnlyList<string> Phrases { get; init; } = Array.Empty<string>();
    public string FlowId { get; init; } = "";
}
'@ | Set-Content "$coreModelsDir\TriggerRule.cs" -Encoding UTF8

@'
namespace TEAI.Chatbot.Core.Models;

public sealed class NormalizedEvent
{
    public string SourceChannel { get; set; } = "";
    public string UserId { get; set; } = "";
    public string PostId { get; set; } = "";
    public string CommentId { get; set; } = "";
    public string OriginalText { get; set; } = "";
    public bool TriggerMatched { get; set; }
    public DateTime CreatedUtc { get; set; }
}
'@ | Set-Content "$coreModelsDir\NormalizedEvent.cs" -Encoding UTF8

@'
namespace TEAI.Chatbot.Core.Models;

public sealed class OutboundMessage
{
    public string TargetChannel { get; set; } = "";
    public string RecipientId { get; set; } = "";
    public string PostId { get; set; } = "";
    public string CommentId { get; set; } = "";
    public string Text { get; set; } = "";
}
'@ | Set-Content "$coreModelsDir\OutboundMessage.cs" -Encoding UTF8

@'
namespace TEAI.Chatbot.Core.Models;

public sealed class OwnerConfig
{
    public string OwnerId { get; set; } = "";
    public string PageId { get; set; } = "";
    public string PageAccessToken { get; set; } = "";
    public string[] TriggerPhrases { get; set; } = Array.Empty<string>();
}
'@ | Set-Content "$coreModelsDir\OwnerConfig.cs" -Encoding UTF8

@'
using TEAI.Chatbot.Core.Models;

namespace TEAI.Chatbot.Core.Flows;

public sealed class FlowContext
{
    public string FlowName { get; }
    public string CorrelationId { get; }
    public NormalizedEvent Event { get; }

    public FlowContext(string flowName, string correlationId, NormalizedEvent ev)
    {
        FlowName = flowName;
        CorrelationId = correlationId;
        Event = ev;
    }
}
'@ | Set-Content "$coreFlowsDir\FlowContext.cs" -Encoding UTF8

@'
namespace TEAI.Chatbot.Core.Flows;

public sealed class FlowResult
{
    public bool Success { get; set; }
    public string Text { get; set; } = "";
    public string? Diagnostic { get; set; }
}
'@ | Set-Content "$coreFlowsDir\FlowResult.cs" -Encoding UTF8

@'
using TEAI.Chatbot.Core.Flows;

namespace TEAI.Chatbot.Core.Flows;

public interface IFlowEngine
{
    Task<FlowResult> HandleAsync(FlowContext ctx, CancellationToken ct = default);
}
'@ | Set-Content "$coreFlowsDir\IFlowEngine.cs" -Encoding UTF8

@'
using TEAI.Chatbot.Core.Flows;

namespace TEAI.Chatbot.Core.Flows;

public sealed class StubFlowEngine : IFlowEngine
{
    public Task<FlowResult> HandleAsync(FlowContext ctx, CancellationToken ct = default)
    {
        var reply = $"[StubFlowEngine] Flow {ctx.FlowName} handled text: \"{ctx.Event.OriginalText}\"";
        return Task.FromResult(new FlowResult
        {
            Success = true,
            Text = reply
        });
    }
}
'@ | Set-Content "$coreFlowsDir\StubFlowEngine.cs" -Encoding UTF8

@'
namespace TEAI.Chatbot.Core.Flows;

public sealed class JsonFlowDefinition
{
    public string Id { get; set; } = "";
    public string Name { get; set; } = "";
    public List<JsonFlowStep> Steps { get; set; } = new();
}

public sealed class JsonFlowStep
{
    public string Id { get; set; } = "";
    public string Type { get; set; } = "";
    public string? Prompt { get; set; }
}
'@ | Set-Content "$coreFlowsDir\JsonFlowDefinition.cs" -Encoding UTF8

@'
using TEAI.Chatbot.Core.Models;
using TEAI.Chatbot.Core.Flows;
using TEAI.Chatbot.Adapters.Llm;

namespace TEAI.Chatbot.Core.Flows;

public sealed class JsonFlowEngine : IFlowEngine
{
    private readonly IChatCompletionClient _llm;

    public JsonFlowEngine(IChatCompletionClient llm)
    {
        _llm = llm;
    }

    public async Task<FlowResult> HandleAsync(FlowContext ctx, CancellationToken ct = default)
    {
        var prompt = $"Flow={ctx.FlowName} Text=\"{ctx.Event.OriginalText}\"";
        var llmResult = await _llm.GetCompletionAsync(prompt, ct);
        return new FlowResult { Success = true, Text = llmResult.Text, Diagnostic = llmResult.Diagnostic };
    }
}
'@ | Set-Content "$coreFlowsDir\JsonFlowEngine.cs" -Encoding UTF8

@'
using TEAI.Chatbot.Core.Models;
using TEAI.Chatbot.Core.Flows;

namespace TEAI.Chatbot.Core.Orchestration;

public interface IConversationOrchestrator
{
    Task<OutboundMessage> HandleAsync(NormalizedEvent ev, CancellationToken ct = default);
}
'@ | Set-Content "$coreOrchDir\IConversationOrchestrator.cs" -Encoding UTF8

@'
using TEAI.Chatbot.Core.Flows;
using TEAI.Chatbot.Core.Models;

namespace TEAI.Chatbot.Core.Orchestration;

public sealed class TeaiConversationOrchestrator : IConversationOrchestrator
{
    private readonly IFlowEngine _engine;

    public TeaiConversationOrchestrator(IFlowEngine engine)
    {
        _engine = engine;
    }

    public async Task<OutboundMessage> HandleAsync(NormalizedEvent ev, CancellationToken ct = default)
    {
        var flowName = "FB_DemoCommentFlow";
        var correlationId = $"{ev.PostId}:{ev.CommentId}";
        var ctx = new FlowContext(flowName, correlationId, ev);

        var result = await _engine.HandleAsync(ctx, ct);

        return new OutboundMessage
        {
            TargetChannel = "FacebookComments",
            RecipientId = ev.UserId,
            PostId = ev.PostId,
            CommentId = ev.CommentId,
            Text = result.Text
        };
    }
}
'@ | Set-Content "$coreOrchDir\TeaiConversationOrchestrator.cs" -Encoding UTF8

# ---------- storage abstractions ----------

Ensure-Dir "src\TEAI.Chatbot.Storage.Abstractions"
$storAbsDir = "src\TEAI.Chatbot.Storage.Abstractions"

@'
using TEAI.Chatbot.Core.Flows;

namespace TEAI.Chatbot.Storage.Abstractions;

public interface IFlowDefinitionStore
{
    Task<JsonFlowDefinition?> GetAsync(string id, CancellationToken ct = default);
    Task SaveAsync(JsonFlowDefinition definition, CancellationToken ct = default);
}
'@ | Set-Content "$storAbsDir\IFlowDefinitionStore.cs" -Encoding UTF8

@'
using TEAI.Chatbot.Core.Models;

namespace TEAI.Chatbot.Storage.Abstractions;

public interface IOwnerConfigStore
{
    Task<OwnerConfig?> GetAsync(string ownerId, CancellationToken ct = default);
    Task SaveAsync(OwnerConfig config, CancellationToken ct = default);
}
'@ | Set-Content "$storAbsDir\IOwnerConfigStore.cs" -Encoding UTF8

# ---------- storage file system ----------

Ensure-Dir "src\TEAI.Chatbot.Storage.FileSystem"
$storFsDir = "src\TEAI.Chatbot.Storage.FileSystem"

@'
using System.Text.Json;
using TEAI.Chatbot.Core.Flows;
using TEAI.Chatbot.Storage.Abstractions;

namespace TEAI.Chatbot.Storage.FileSystem;

public sealed class FileFlowDefinitionStore : IFlowDefinitionStore
{
    private readonly string _root;

    public FileFlowDefinitionStore(string? root = null)
    {
        _root = root ?? Path.Combine(AppContext.BaseDirectory, "data", "flows");
    }

    public async Task<JsonFlowDefinition?> GetAsync(string id, CancellationToken ct = default)
    {
        var path = Path.Combine(_root, $"{id}.json");
        if (!File.Exists(path)) return null;

        var json = await File.ReadAllTextAsync(path, ct);
        return JsonSerializer.Deserialize<JsonFlowDefinition>(json);
    }

    public async Task SaveAsync(JsonFlowDefinition definition, CancellationToken ct = default)
    {
        Directory.CreateDirectory(_root);
        var path = Path.Combine(_root, $"{definition.Id}.json");
        var json = JsonSerializer.Serialize(definition, new JsonSerializerOptions { WriteIndented = true });
        await File.WriteAllTextAsync(path, json, ct);
    }
}
'@ | Set-Content "$storFsDir\FileFlowDefinitionStore.cs" -Encoding UTF8

@'
using System.Text.Json;
using TEAI.Chatbot.Core.Models;
using TEAI.Chatbot.Storage.Abstractions;

namespace TEAI.Chatbot.Storage.FileSystem;

public sealed class FileOwnerConfigStore : IOwnerConfigStore
{
    private readonly string _root;

    public FileOwnerConfigStore(string? root = null)
    {
        _root = root ?? Path.Combine(AppContext.BaseDirectory, "data", "owners");
    }

    public async Task<OwnerConfig?> GetAsync(string ownerId, CancellationToken ct = default)
    {
        var path = Path.Combine(_root, $"{ownerId}.json");
        if (!File.Exists(path)) return null;

        var json = await File.ReadAllTextAsync(path, ct);
        return JsonSerializer.Deserialize<OwnerConfig>(json);
    }

    public async Task SaveAsync(OwnerConfig config, CancellationToken ct = default)
    {
        Directory.CreateDirectory(_root);
        var path = Path.Combine(_root, $"{config.OwnerId}.json");
        var json = JsonSerializer.Serialize(config, new JsonSerializerOptions { WriteIndented = true });
        await File.WriteAllTextAsync(path, json, ct);
    }
}
'@ | Set-Content "$storFsDir\FileOwnerConfigStore.cs" -Encoding UTF8

# ---------- adapters: LLM ----------

Ensure-Dir "src\TEAI.Chatbot.Adapters.Llm"
$llmDir = "src\TEAI.Chatbot.Adapters.Llm"

@'
using TEAI.Chatbot.Core.Flows;

namespace TEAI.Chatbot.Adapters.Llm;

public sealed class ChatCompletionResult
{
    public string Text { get; set; } = "";
    public string? Diagnostic { get; set; }
}

public interface IChatCompletionClient
{
    Task<ChatCompletionResult> GetCompletionAsync(string prompt, CancellationToken ct = default);
}
'@ | Set-Content "$llmDir\IChatCompletionClient.cs" -Encoding UTF8

@'
namespace TEAI.Chatbot.Adapters.Llm;

public sealed class StubChatCompletionClient : IChatCompletionClient
{
    public Task<ChatCompletionResult> GetCompletionAsync(string prompt, CancellationToken ct = default)
    {
        var result = new ChatCompletionResult
        {
            Text = "[Stub LLM] This is a demo reply based on your comment.",
            Diagnostic = "StubChatCompletionClient"
        };

        return Task.FromResult(result);
    }
}
'@ | Set-Content "$llmDir\StubChatCompletionClient.cs" -Encoding UTF8

# ---------- adapters: Channels ----------

Ensure-Dir "src\TEAI.Chatbot.Adapters.Channels"
$chanDir = "src\TEAI.Chatbot.Adapters.Channels"

@'
namespace TEAI.Chatbot.Adapters.Channels;

public sealed class TeaiPostMessageDto
{
    public string? PostId { get; set; }
    public string? CommentId { get; set; }
    public string? Text { get; set; }
    public string? PageId { get; set; }
    public string? UserId { get; set; }
}
'@ | Set-Content "$chanDir\TeaiPostMessageDto.cs" -Encoding UTF8

@'
using TEAI.Chatbot.Core.Models;

namespace TEAI.Chatbot.Adapters.Channels;

public interface ITeaiPostNormalizer
{
    NormalizedEvent Normalize(TeaiPostMessageDto dto);
}
'@ | Set-Content "$chanDir\ITeaiPostNormalizer.cs" -Encoding UTF8

@'
using TEAI.Chatbot.Core.Models;

namespace TEAI.Chatbot.Adapters.Channels;

public sealed class TeaiPostNormalizer : ITeaiPostNormalizer
{
    public NormalizedEvent Normalize(TeaiPostMessageDto dto)
    {
        return new NormalizedEvent
        {
            SourceChannel = "TeaiWebsite",
            UserId = dto.UserId ?? "",
            PostId = dto.PostId ?? "",
            CommentId = dto.CommentId ?? "",
            OriginalText = dto.Text ?? "",
            TriggerMatched = true,
            CreatedUtc = DateTime.UtcNow
        };
    }
}
'@ | Set-Content "$chanDir\TeaiPostNormalizer.cs" -Encoding UTF8

# ---------- adapters: LangGraph shell ----------

Ensure-Dir "src\TEAI.Chatbot.Adapters.LangGraph"
$langDir = "src\TEAI.Chatbot.Adapters.LangGraph"

@'
namespace TEAI.Chatbot.Adapters.LangGraph;

public sealed class LangGraphOptions
{
    public string Endpoint { get; set; } = "";
}

public sealed class LangGraphResult
{
    public string Text { get; set; } = "";
}
'@ | Set-Content "$langDir\LangGraphOptions.cs" -Encoding UTF8

@'
namespace TEAI.Chatbot.Adapters.LangGraph;

public interface ILangGraphClient
{
    Task<LangGraphResult> InvokeAsync(string flowName, string input, CancellationToken ct = default);
}
'@ | Set-Content "$langDir\ILangGraphClient.cs" -Encoding UTF8

@'
using System.Net.Http.Json;
using Microsoft.Extensions.Configuration;

namespace TEAI.Chatbot.Adapters.LangGraph;

public sealed class HttpLangGraphClient : ILangGraphClient
{
    private readonly HttpClient _client;
    private readonly string _endpoint;

    public HttpLangGraphClient(HttpClient client, IConfiguration cfg)
    {
        _client = client;
        _endpoint = cfg["LangGraph:Endpoint"] ?? throw new InvalidOperationException("LangGraph endpoint missing");
    }

    public async Task<LangGraphResult> InvokeAsync(string flowName, string input, CancellationToken ct = default)
    {
        var payload = new { flow = flowName, text = input };
        var response = await _client.PostAsJsonAsync(_endpoint, payload, ct);
        response.EnsureSuccessStatusCode();
        var result = await response.Content.ReadFromJsonAsync<LangGraphResult>(cancellationToken: ct);
        return result ?? new LangGraphResult { Text = "[LangGraph] Empty result" };
    }
}
'@ | Set-Content "$langDir\HttpLangGraphClient.cs" -Encoding UTF8

# ---------- Ingress.Api Program.cs ----------

$ingressDir = "src\TEAI.Chatbot.Ingress.Api"
Ensure-Dir $ingressDir

@'
using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using TEAI.Chatbot.Adapters.Channels;
using TEAI.Chatbot.Adapters.Llm;
using TEAI.Chatbot.Core.Flows;
using TEAI.Chatbot.Core.Models;
using TEAI.Chatbot.Core.Orchestration;
using TEAI.Chatbot.Storage.Abstractions;
using TEAI.Chatbot.Storage.FileSystem;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddHttpClient();
builder.Services.AddScoped<IChatCompletionClient, StubChatCompletionClient>();
builder.Services.AddScoped<IFlowEngine, JsonFlowEngine>();
builder.Services.AddScoped<IConversationOrchestrator, TeaiConversationOrchestrator>();
builder.Services.AddScoped<ITeaiPostNormalizer, TeaiPostNormalizer>();
builder.Services.AddSingleton<IFlowDefinitionStore, FileFlowDefinitionStore>();
builder.Services.AddSingleton<IOwnerConfigStore, FileOwnerConfigStore>();

var app = builder.Build();

app.MapPost("/ingress", async (
    NormalizedEvent ev,
    IConversationOrchestrator orchestrator,
    CancellationToken ct) =>
{
    var outbound = await orchestrator.HandleAsync(ev, ct);
    return Results.Ok(outbound);
});

app.Run();
'@ | Set-Content "$ingressDir\Program.cs" -Encoding UTF8

# ---------- Owner.Api Program.cs ----------

$ownerDir = "src\TEAI.Chatbot.Owner.Api"
Ensure-Dir $ownerDir

@'
using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using TEAI.Chatbot.Core.Flows;
using TEAI.Chatbot.Storage.Abstractions;
using TEAI.Chatbot.Storage.FileSystem;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddSingleton<IFlowDefinitionStore, FileFlowDefinitionStore>();
builder.Services.AddSingleton<IOwnerConfigStore, FileOwnerConfigStore>();

var app = builder.Build();

app.MapGet("/flows/{id}", async (string id, IFlowDefinitionStore store, CancellationToken ct) =>
{
    var def = await store.GetAsync(id, ct);
    return def is null ? Results.NotFound() : Results.Ok(def);
});

app.MapPost("/flows/{id}", async (string id, JsonFlowDefinition def, IFlowDefinitionStore store, CancellationToken ct) =>
{
    def.Id = id;
    await store.SaveAsync(def, ct);
    return Results.Ok();
});

app.Run();
'@ | Set-Content "$ownerDir\Program.cs" -Encoding UTF8

# ---------- FakeSocialEventRunner stub ----------

$fakeRunnerPath = Join-Path $Root "tools\FakeSocialEventRunner.ps1"
if (-not (Test-Path $fakeRunnerPath)) {
    @'
param(
    [string]$IngressUrl = "http://localhost:5000/ingress"
)

Write-Host "Starting FakeSocialEventRunner.ps1"
Write-Host "IngressUrl: $IngressUrl"

$payload = @{
    SourceChannel  = "LocalDemo"
    UserId         = "USER_001"
    PostId         = "POST_001"
    CommentId      = "CMT_001"
    OriginalText   = "!teai demo comment from harness"
    TriggerMatched = $true
    CreatedUtc     = [DateTime]::UtcNow
}

$json = $payload | ConvertTo-Json -Depth 5
Write-Host "Posting:"
Write-Host $json

try {
    $resp = Invoke-RestMethod -Uri $IngressUrl -Method Post -Body $json -ContentType "application/json"
    Write-Host "Response:"
    $resp | ConvertTo-Json -Depth 5
}
catch {
    Write-Warning "Error calling ingress: $($_.Exception.Message)"
}
'@ | Set-Content -Path $fakeRunnerPath -Encoding UTF8
    Write-Host "Created tools\FakeSocialEventRunner.ps1 stub"
}

# ---------- solutions ----------

New-SlnIfMissing -SlnName "TEAIChatbot.Server"
New-SlnIfMissing -SlnName "TEAIChatbot.Azure"
New-SlnIfMissing -SlnName "TEAIChatbot.Tests"
New-SlnIfMissing -SlnName "TEAIChatbot.Client"

# server solution
Add-ToSlnIfMissing -SlnName "TEAIChatbot.Server" -ProjRelativePath "src\TEAI.Chatbot.Core\TEAI.Chatbot.Core.csproj"
Add-ToSlnIfMissing -SlnName "TEAIChatbot.Server" -ProjRelativePath "src\TEAI.Chatbot.Storage.Abstractions\TEAI.Chatbot.Storage.Abstractions.csproj"
Add-ToSlnIfMissing -SlnName "TEAIChatbot.Server" -ProjRelativePath "src\TEAI.Chatbot.Storage.FileSystem\TEAI.Chatbot.Storage.FileSystem.csproj"
Add-ToSlnIfMissing -SlnName "TEAIChatbot.Server" -ProjRelativePath "src\TEAI.Chatbot.Adapters.Channels\TEAI.Chatbot.Adapters.Channels.csproj"
Add-ToSlnIfMissing -SlnName "TEAIChatbot.Server" -ProjRelativePath "src\TEAI.Chatbot.Adapters.Llm\TEAI.Chatbot.Adapters.Llm.csproj"
Add-ToSlnIfMissing -SlnName "TEAIChatbot.Server" -ProjRelativePath "src\TEAI.Chatbot.Adapters.LangGraph\TEAI.Chatbot.Adapters.LangGraph.csproj"
Add-ToSlnIfMissing -SlnName "TEAIChatbot.Server" -ProjRelativePath "src\TEAI.Chatbot.Ingress.Api\TEAI.Chatbot.Ingress.Api.csproj"
Add-ToSlnIfMissing -SlnName "TEAIChatbot.Server" -ProjRelativePath "src\TEAI.Chatbot.Owner.Api\TEAI.Chatbot.Owner.Api.csproj"

# azure solution (functions placeholder + core + llm)
Add-ToSlnIfMissing -SlnName "TEAIChatbot.Azure" -ProjRelativePath "src\TEAI.Chatbot.Core\TEAI.Chatbot.Core.csproj"
Add-ToSlnIfMissing -SlnName "TEAIChatbot.Azure" -ProjRelativePath "src\TEAI.Chatbot.Adapters.Llm\TEAI.Chatbot.Adapters.Llm.csproj"
Add-ToSlnIfMissing -SlnName "TEAIChatbot.Azure" -ProjRelativePath "src\TEAI.Chatbot.Ingress.Functions\TEAI.Chatbot.Ingress.Functions.csproj"

# tests solution
Add-ToSlnIfMissing -SlnName "TEAIChatbot.Tests" -ProjRelativePath "tests\TEAI.Chatbot.Core.Tests\TEAI.Chatbot.Core.Tests.csproj"
Add-ToSlnIfMissing -SlnName "TEAIChatbot.Tests" -ProjRelativePath "tests\TEAI.Chatbot.Ingress.Tests\TEAI.Chatbot.Ingress.Tests.csproj"
Add-ToSlnIfMissing -SlnName "TEAIChatbot.Tests" -ProjRelativePath "tests\TEAI.Chatbot.Owner.Tests\TEAI.Chatbot.Owner.Tests.csproj"

Add-ToSlnIfMissing -SlnName "TEAIChatbot.Tests" -ProjRelativePath "src\TEAI.Chatbot.Core\TEAI.Chatbot.Core.csproj"
Add-ToSlnIfMissing -SlnName "TEAIChatbot.Tests" -ProjRelativePath "src\TEAI.Chatbot.Ingress.Api\TEAI.Chatbot.Ingress.Api.csproj"
Add-ToSlnIfMissing -SlnName "TEAIChatbot.Tests" -ProjRelativePath "src\TEAI.Chatbot.Owner.Api\TEAI.Chatbot.Owner.Api.csproj"

Write-Host ""
Write-Host "=== Summary ==="
Write-Host "Server solution: TEAIChatbot.Server.sln"
Write-Host "Azure solution:  TEAIChatbot.Azure.sln"
Write-Host "Tests solution:  TEAIChatbot.Tests.sln"
Write-Host "Client solution: TEAIChatbot.Client.sln (empty shell for React)"
Write-Host ""
Write-Host "Try:"
Write-Host "  dotnet build TEAIChatbot.Server.sln"
Write-Host "  dotnet test  TEAIChatbot.Tests.sln"
Write-Host "Then:"
Write-Host "  dotnet run --project src\TEAI.Chatbot.Ingress.Api\TEAI.Chatbot.Ingress.Api.csproj"
Write-Host "  pwsh .\tools\FakeSocialEventRunner.ps1"

