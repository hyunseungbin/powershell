function Check-Network {
    param (
        [array]$targetHost,
        [int]$interval
    )

    while ($true) {
        foreach ($hosts in $targetHost) {
            $response = Test-Connection -ComputerName $hosts -Count 1 -ErrorAction SilentlyContinue
            if ($response) {
                Write-Host "Response time for Address: $($response.Address) / Latency: $($response.Latency) ms / Status: $($response.Status)"
            } else {
                Write-Host "No response from $host"
            }
        }

        Start-Sleep -Seconds $interval
    }
}

$targetHost = (
    "8.8.8.8",
    "9.9.9.9",
    "7.7.7.7"
)
$interval = 5  # Time interval between checks (in seconds)

Check-Network -targetHost $targetHost -interval $interval