# Funkcja do pobierania informacji o RAM
function Get-RAMInfo {
    $compSys = Get-CimInstance Win32_ComputerSystem
    $totalRAM = [math]::Round($compSys.TotalPhysicalMemory / 1GB, 2)
    Write-Output "Total RAM: $totalRAM GB"
}

# Funkcja do pobierania informacji o użyciu dysku
function Get-DiskUsage {
    $drives = Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3"
    foreach ($drive in $drives) {
        $total = [math]::Round($drive.Size / 1GB, 2)
        $free = [math]::Round($drive.FreeSpace / 1GB, 2)
        $used = [math]::Round($total - $free, 2)
        $percentUsed = [math]::Round(($used / $total) * 100, 2)
        Write-Output "Drive $($drive.DeviceID): Used $used GB / $total GB ($percentUsed%)"
    }
}

# Funkcja do pobierania nazwy hosta
function Get-Hostname {
    $hostname = $env:COMPUTERNAME
    Write-Output "Hostname: $hostname"
}

# Funkcja do pobierania nazwy systemu operacyjnego
function Get-OSName {
    $os = Get-CimInstance Win32_OperatingSystem
    Write-Output "Operating System: $($os.Caption)"
}

# Funkcja sterująca jak case w bashu
function Show-SystemInfo {
    param (
        [string]$Option
    )

    switch ($Option.ToLower()) {
        "ram"      { Get-RAMInfo }
        "disk"     { Get-DiskUsage }
        "hostname" { Get-Hostname }
        "os"       { Get-OSName }
        "all"      {
            Get-RAMInfo
            Get-DiskUsage
            Get-Hostname
            Get-OSName
        }
        default {
            Write-Output "Użycie: Show-SystemInfo [ram | disk | hostname | os | all]"
        }
    }
}

# Przykład użycia (dla testu):
# Show-SystemInfo "ram"
# Show-SystemInfo "all"
