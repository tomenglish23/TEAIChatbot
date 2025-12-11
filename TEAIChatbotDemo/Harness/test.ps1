
$postId    = "104514410976905_1205906201672836"
$postId    = "104514410976905_1234567890123456"
$pageToken = "EAATdyGUGIF0BQMTG3mW6U0xItorI446YxSShWyCEcNZCYgkzAJVa1j7sB3SfR39buTrWhl7VnLDeoVDUGLlncQ0S9QZBZCxtEZANFKUwNThBAv2rSdPrZCODS07UPZCiDwy1A6NsnfBAZC4CcAx9rCvFsSsX4hhoNwR5VasxZCf41UID1Dw4zgiTEiULXFvqzZAZBxKZBClkKPTuj5jZBgCqrk6xxXOdZC0VccHUwByKEErJ9"   # your real Page access token from /me/accounts

$pageToken = "pfbid027vUog6VKVWSYoEL6as8cVcswTR1h9fUADxKEDSQBwFmegBS6GPawTWYgJp2jnT49l"



$uri = "https://graph.facebook.com/v21.0/$postId/comments?order=chronological&limit=1&access_token=$pageToken"

try {
    $response = Invoke-RestMethod -Uri $uri -Method Get -ErrorAction Stop
    $response | ConvertTo-Json -Depth 10
}
catch {
    $resp   = $_.Exception.Response
    if ($resp) {
        $reader = New-Object System.IO.StreamReader($resp.GetResponseStream())
        $reader.ReadToEnd()
    } else {
        $_
    }
}
