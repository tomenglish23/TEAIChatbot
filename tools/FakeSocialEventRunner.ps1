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
