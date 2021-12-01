## Function to get the up time from a server.
Function Get-UpTime
{
    param([string] $LastBootTime)
    $Uptime = (Get-Date) - [System.Management.ManagementDateTimeconverter]::ToDateTime($LastBootTime)
    "$($Uptime.Days) days $($Uptime.Hours)h $($Uptime.Minutes)m"
}
    ## Sort Servers based on whether they are online or offline
    $ServerList = $ServerList | Sort-Object

    ForEach ($ServerName in $ServerList)
    {
        $PingStatus = Test-Connection -ComputerName $ServerName -Count 1 -Quiet

        If ($PingStatus -eq $False)
        {
            $ServersOffline += @($ServerName)
        }

        Else
        {
            $ServersOnline += @($ServerName)
        }
    }

    $ServerListFinal = $ServersOffline + $ServersOnline

        ## Look through the final servers list.
        ForEach ($ServerName in $ServerListFinal)
        {
            $PingStatus = Test-Connection -ComputerName $ServerName -Count 1 -Quiet
    
            ## If server responds, get the stats for the server.
            If ($PingStatus)
            {
                #$CpuAlert = $false
                #$MemAlert = $false
                #$DiskAlert = $false
                #$OperatingSystem = Get-WmiObject Win32_OperatingSystem -ComputerName $ServerName
                #$CpuUsage = Get-WmiObject Win32_Processor -Computername $ServerName | Measure-Object -Property LoadPercentage -Average | ForEach-Object {$_.Average; If($_.Average -ge $CpuAlertThreshold){$CpuAlert = $True};}
                #$Uptime = Get-Uptime($OperatingSystem.LastBootUpTime)
                #$MemUsage = Get-WmiObject -Class Win32_OperatingSystem -ComputerName $ServerName | ForEach-Object {“{0:N0}” -f ((($_.TotalVisibleMemorySize - $_.FreePhysicalMemory) * 100)/ $_.TotalVisibleMemorySize); If((($_.TotalVisibleMemorySize - $_.FreePhysicalMemory) * 100)/ $_.TotalVisibleMemorySize -ge $MemAlertThreshold){$MemAlert = $True};}
                #$DiskUsage = Get-WmiObject Win32_LogicalDisk -ComputerName $ServerName | Where-Object {$_.DriveType -eq 3} | Foreach-Object {$_.DeviceID, [Math]::Round((($_.Size - $_.FreeSpace) * 100)/ $_.Size); If([Math]::Round((($_.Size - $_.FreeSpace) * 100)/ $_.Size) -ge $DiskAlertThreshold){$DiskAlert = $True};}
           }
            ## Put the results together in an array.
            $Result += New-Object PSObject -Property @{
	                ServerName = $ServerName
		                Status = $PingStatus
                            
                #CpuUsage = $CpuUsage
                #CpuAlert = $CpuAlert
		        #Uptime = $Uptime
                #MemUsage = $MemUsage
                #MemAlert = $MemAlert
                #DiskUsage = $DiskUsage
                #DiskAlert = $DiskAlert
	    }
    
        ## Clear the variables after obtaining and storing the results, otherwise data is duplicated.

        If ($ServerListFinal)
        {
            Clear-Variable ServerListFinal
        }

        If ($ServersOffline)
        {
            Clear-Variable ServersOffline
        }

        If ($ServersOnline)
        {
            Clear-Variable ServersOnline
        }

        If ($PingStatus)
        {
            Clear-Variable PingStatus
        }

        If ($CpuUsage)
        {
            Clear-Variable CpuUsage
        }

        If ($Uptime)
        {
            Clear-Variable Uptime
        }

        If ($MemUsage)
        {
            Clear-Variable MemUsage
        }

        If ($DiskUsage)
        {
            Clear-Variable DiskUsage
        }

}
