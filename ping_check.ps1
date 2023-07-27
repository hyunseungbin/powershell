function Check-Network {
    param (
        [String]$targetHost,
        [int]$interval
    )

    while ($true) {
        $response = Test-Connection -ComputerName $targetHost -Count 1 -ErrorAction SilentlyContinue
        Test-Connection -ComputerName $targetHost -Count 1 -ErrorAction SilentlyContinue

        if ($response) {
            Write-Host "Response time: $($response.Latency) ms"
        } else {
            Write-Host "No response"
            Show-BalloonTip -title "Network Monitor" -message "No response from the target host." -icon "Warning"
        }

        Start-Sleep -Seconds $interval
    }
}

$interval = 5  # Time interval between checks (in seconds)
$targetHost = "8.8.8.8"

Check-Network -targetHost $targetHost -interval $interval
