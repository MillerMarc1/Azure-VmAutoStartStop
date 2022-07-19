# Input bindings are passed in via param block.
param($Timer)
 
# Get the current universal time in the default string format.
$currentUTCtime = (Get-Date).ToUniversalTime()
 
# The 'IsPastDue' property is 'true' when the current function invocation is later than scheduled.
if ($Timer.IsPastDue) {
    Write-Host "PowerShell timer is running late!"
}
 
# Get current time to compare against tag values
$currentTime = [System.TimeZoneInfo]::ConvertTimeBySystemTimeZoneId([DateTime]::Now,"US Eastern Standard Time")
 
# Get all VMs with Shutdown_Time and Start_Time tags
$vms = Get-AzVM -Status | Where-Object {($_.tags['Shutdown_Time'] -ne $null) -and ($_.tags['Start_Time'] -ne $null)}
 
# Loop over all VMs with the tags and start/stop accordingly
foreach ($vm in $vms) {
    $shutdownTime = $vm.Tags['Shutdown_Time']
    $shutdownTime = Get-date($shutdownTime)
    $startupTime = $vm.Tags['Start_Time']
    $startupTime = Get-Date($startupTime)
 
    Write-Host "Current time: " + $currentTime
    Write-Host $vm.Name + " startup time: " $startupTime
    Write-Host $vm.Name + " shutdown time: " $shutdownTime
 
    if (($vm.PowerState -eq "VM running") -and ($currentTime -ge $shutdownTime)) {
        Write-Host "Stopping VM"
        $vm.Name
        Stop-AzVM -Name $vm.Name -ResourceGroupName $vm.ResourceGroupName -Force -NoWait | Out-Null
        Write-Host "VM has been stopped"
    }
 
   
    if (($vm.PowerState -eq "VM deallocated") -and ($currentTime -ge $startupTime) -and ($currentTime -lt $shutdownTime)) {
        Write-Host "Starting VM"
        $vm.Name
        Start-AzVM -Name $vm.name -ResourceGroupName $vm.ResourceGroupName -NoWait | Out-Null
        Write-Host "VM has been started"
    }
}
 
# Write an information log with the current time.
Write-Host "PowerShell timer trigger function ran! TIME: $currentUTCtime"
