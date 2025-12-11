param(
    [string]$ConfigPath = "$PSScriptRoot\social\FacebookWebhookConfig.json",
    [string]$IngressUrl = "http://localhost:5000/ingress",
    [string]$StatePath  = "$PSScriptRoot\state\LastCommentTime.txt"
)

# Simple FB comment poller for a single demo post.
# 1. Reads PageId, DemoPostId, PageAccessToken, TriggerPhrases from config.
# 2. Polls comments on the post.
# 3. When a trigger hits, builds NormalizedEvent JSON.
# 4. POSTs to local /ingress.
# 5. Sends reply back via Graph API.

if (-not (Test-Path $ConfigPath)) {
    throw "Config file not found at $ConfigPath"
}

$config = Get-Content $ConfigPath -Raw | ConvertFrom-Json

$PageId         = $config.PageId
$DemoPostId     = $config.DemoPostId
$PageToken      = $config.PageAccessToken
$TriggerPhrases = $config.TriggerPhrases

# Ensure state folder exists
$stateDir = Split-Path $StatePath
if (-not (Test-Path $stateDir)) {
    New-Item -ItemType Directory -Path $stateDir | Out-Null
}

# Simple checkpoint so you do not reprocess old comments
if (Test-Path $StatePath) {
    $LastSeen = Get-Date (Get-Content $StatePath -Raw)
} else {
    $LastSeen = (Get-Date).AddMinutes(-10)
}

Write-Host "Starting FakeSocialEventRunner.ps1"
Write-Host "Page: $PageId  Post: $DemoPostId"
Write-Host "IngressUrl: $IngressUrl"
Write-Host "Initial LastSeen: $LastSeen"

function Test-ContainsTrigger {
    param(
        [string]$Text,
        [string[]]$Triggers
    )

    foreach ($t in $Triggers) {
        if ($Text -like "*$t*") { return $true }
    }
    return $false
}

while ($true) {
    try {
        $commentsUri = "https://graph.facebook.com/v21.0/$DemoPostId/comments?access_token=$PageToken&order=chronological&limit=25"
        $comments    = Invoke-RestMethod -Uri $commentsUri -Method Get

        if (-not $comments.data) {
            Start-Sleep -Seconds 5
            continue
        }

        foreach ($c in $comments.data) {
            $created = Get-Date $c.created_time
            $fromId  = $c.from.id
            $text    = $c.message

            # Skip already processed
            if ($created -le $LastSeen) { continue }

            # Skip comments from the Page itself
            if ($fromId -eq $PageId) { continue }

            Write-Host ""
            Write-Host "New comment from $fromId at $created"
            Write-Host "Text: $text"

            $triggerMatched = Test-ContainsTrigger -Text $text -Triggers $TriggerPhrases
            if (-not $triggerMatched) {
                Write-Host "No trigger phrase found, skipping"
                if ($created -gt $LastSeen) { $LastSeen = $created }
                continue
            }

            Write-Host "Trigger phrase matched, building NormalizedEvent"

            $normalized = [pscustomobject]@{
                SourceChannel  = "FacebookComments"
                UserId         = $fromId
                PostId         = $DemoPostId
                CommentId      = $c.id
                OriginalText   = $text
                TriggerMatched = $true
                CreatedUtc     = $created.ToUniversalTime().ToString("o")
            }

            $jsonBody = $normalized | ConvertTo-Json -Depth 5

            Write-Host "Calling ingress at $IngressUrl"
            $outbound = Invoke-RestMethod -Uri $IngressUrl -Method Post -ContentType "application/json" -Body $jsonBody

            if (-not $outbound) {
                Write-Host "Ingress returned no response, skipping send"
                if ($created -gt $LastSeen) { $LastSeen = $created }
                continue
            }

            $recipientId = $outbound.RecipientId
            $replyText   = $outbound.Text

            Write-Host "Sending reply to user $recipientId"
            Write-Host "Reply text: $replyText"

            $payload = @{
                recipient = @{ id = $recipientId }
                message   = @{ text = $replyText }
            } | ConvertTo-Json -Depth 5

            $sendUri   = "https://graph.facebook.com/v21.0/me/messages?access_token=$PageToken"
            $sendResult = Invoke-RestMethod -Uri $sendUri -Method Post -ContentType "application/json" -Body $payload

            Write-Host "Send result: $($sendResult | ConvertTo-Json -Depth 3)"

            if ($created -gt $LastSeen) { $LastSeen = $created }
        }

        $LastSeen.ToString("o") | Set-Content -Path $StatePath -Encoding UTF8
        Start-Sleep -Seconds 5
    }
    catch {
        Write-Warning "Error in polling loop: $_"
        Start-Sleep -Seconds 10
    }
}
