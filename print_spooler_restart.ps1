$session_servers = @(
    'computer_name'
)

Write-Host "Connect to the relevant session."
foreach ($server in $session_servers) {
    $session = New-PSSession -ComputerName $server
    # Restart the Print Spooler service on the target server
    if ($session){
        Write-Host "$server : Connect to the relevant session."

        Invoke-Command -Session $session -ScriptBlock {
        # Stop the Print Spooler service
        Write-Host "Stopping Print Spooler service..."
        #Write-Host ""
        Stop-Service -Name "Spooler" -Force

        # Wait for a few seconds to allow the service to stop
        Start-Sleep -Seconds 3

        # Check if the Print Spooler service is still running
        if ((Get-Service -Name "Spooler").Status -eq "Running") {
            Write-Host "Failed to stop Print Spooler service. Please try again or restart your computer."
            exit 3
        }

        # Start the Print Spooler service
        Write-Host "Starting Print Spooler service..."
        #Write-Host ""
        Start-Service -Name "Spooler"

        # Check if the Print Spooler service is running
        if ((Get-Service -Name "Spooler").Status -eq "Running") {
            Write-Host "Print Spooler service successfully restarted."
            Write-Host ""
        } else {
            Write-Host "Failed to start Print Spooler service. Please try again or restart your computer."
        }
    }
    #Write-Host "$server : Close the associate session."
    Remove-PSSession -Session $session
    }
    
}
Write-Host "$(Get-Date) Print service restart complete"
Write-Host "Close the associate session."
