param(
    [string]$Root = (Get-Location).Path
)

Set-Location $Root
Write-Host "Root: $Root"

function Add-Ref {
    param(
        [string]$From,
        [string]$To
    )

    $fromPath = Join-Path $Root $From
    $toPath   = Join-Path $Root $To

    if (-not (Test-Path $fromPath)) {
        Write-Warning "From project missing: $From"
        return
    }
    if (-not (Test-Path $toPath)) {
        Write-Warning "To project missing:   $To"
        return
    }

    Write-Host "dotnet add `"$From`" reference `"$To`""
    dotnet add $From reference $To
}

# 1) Core depends on Adapters.Llm (JsonFlowEngine uses IChatCompletionClient)
Add-Ref `
  "src\TEAI.Chatbot.Core\TEAI.Chatbot.Core.csproj" `
  "src\TEAI.Chatbot.Adapters.Llm\TEAI.Chatbot.Adapters.Llm.csproj"

# 2) Storage.Abstractions uses Core types (JsonFlowDefinition & OwnerConfig)
Add-Ref `
  "src\TEAI.Chatbot.Storage.Abstractions\TEAI.Chatbot.Storage.Abstractions.csproj" `
  "src\TEAI.Chatbot.Core\TEAI.Chatbot.Core.csproj"

# 3) Storage.FileSystem implements abstractions & uses Core models
Add-Ref `
  "src\TEAI.Chatbot.Storage.FileSystem\TEAI.Chatbot.Storage.FileSystem.csproj" `
  "src\TEAI.Chatbot.Storage.Abstractions\TEAI.Chatbot.Storage.Abstractions.csproj"

Add-Ref `
  "src\TEAI.Chatbot.Storage.FileSystem\TEAI.Chatbot.Storage.FileSystem.csproj" `
  "src\TEAI.Chatbot.Core\TEAI.Chatbot.Core.csproj"

# 4) Channel adapter uses NormalizedEvent from Core
Add-Ref `
  "src\TEAI.Chatbot.Adapters.Channels\TEAI.Chatbot.Adapters.Channels.csproj" `
  "src\TEAI.Chatbot.Core\TEAI.Chatbot.Core.csproj"

# 5) Ingress.Api needs Core, adapters, storage
Add-Ref `
  "src\TEAI.Chatbot.Ingress.Api\TEAI.Chatbot.Ingress.Api.csproj" `
  "src\TEAI.Chatbot.Core\TEAI.Chatbot.Core.csproj"

Add-Ref `
  "src\TEAI.Chatbot.Ingress.Api\TEAI.Chatbot.Ingress.Api.csproj" `
  "src\TEAI.Chatbot.Adapters.Channels\TEAI.Chatbot.Adapters.Channels.csproj"

Add-Ref `
  "src\TEAI.Chatbot.Ingress.Api\TEAI.Chatbot.Ingress.Api.csproj" `
  "src\TEAI.Chatbot.Adapters.Llm\TEAI.Chatbot.Adapters.Llm.csproj"

Add-Ref `
  "src\TEAI.Chatbot.Ingress.Api\TEAI.Chatbot.Ingress.Api.csproj" `
  "src\TEAI.Chatbot.Storage.Abstractions\TEAI.Chatbot.Storage.Abstractions.csproj"

Add-Ref `
  "src\TEAI.Chatbot.Ingress.Api\TEAI.Chatbot.Ingress.Api.csproj" `
  "src\TEAI.Chatbot.Storage.FileSystem\TEAI.Chatbot.Storage.FileSystem.csproj"

# 6) Owner.Api needs Core (JsonFlowDefinition) & storage
Add-Ref `
  "src\TEAI.Chatbot.Owner.Api\TEAI.Chatbot.Owner.Api.csproj" `
  "src\TEAI.Chatbot.Core\TEAI.Chatbot.Core.csproj"

Add-Ref `
  "src\TEAI.Chatbot.Owner.Api\TEAI.Chatbot.Owner.Api.csproj" `
  "src\TEAI.Chatbot.Storage.Abstractions\TEAI.Chatbot.Storage.Abstractions.csproj"

Add-Ref `
  "src\TEAI.Chatbot.Owner.Api\TEAI.Chatbot.Owner.Api.csproj" `
  "src\TEAI.Chatbot.Storage.FileSystem\TEAI.Chatbot.Storage.FileSystem.csproj"

# 7) (Optional for later) Functions project reuses Core & Llm adapter
if (Test-Path "src\TEAI.Chatbot.Ingress.Functions\TEAI.Chatbot.Ingress.Functions.csproj") {
    Add-Ref `
      "src\TEAI.Chatbot.Ingress.Functions\TEAI.Chatbot.Ingress.Functions.csproj" `
      "src\TEAI.Chatbot.Core\TEAI.Chatbot.Core.csproj"

    Add-Ref `
      "src\TEAI.Chatbot.Ingress.Functions\TEAI.Chatbot.Ingress.Functions.csproj" `
      "src\TEAI.Chatbot.Adapters.Llm\TEAI.Chatbot.Adapters.Llm.csproj"
}

Write-Host ""
Write-Host "Reference wiring complete."

