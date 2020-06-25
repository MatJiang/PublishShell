<#
publish script
requires -version 3 or higher
#>
[string]$date = Get-Date -format "yyyyMMddHHmmss"
# Compare Folder
$targetPath = "I:\Target" # Target Dir
[string]$location = "I:\power" # Get-Location ps1 Folder location,but not working with .bat calling
$backUpPath = "$location\BackUp\$date\WorkingFolder"
# Source Folder
$sourcePath = "$location\Publish"
if (!(Test-Path $sourcePath)) {
    New-Item -Path $sourcePath -ItemType Directory
}

$logPath = "$location\BackUp\$date\Log"
$logFile = "$logPath\Copied.log.txt"
$logNewFile = "$logPath\NewFile.log.txt"
# Create Log File
Write-Host "Create Log Files..."
New-Item -Force $logFile
New-Item -Force $logNewFile

Write-Host "`nBackUp Folder=>$backUpPath`nSorce Folder=>$sourcePath`nLogs Folder=>$logPath`n`nFolders Ready Finished...`nProgram Starting...`n"

# -File Read File Only
$files = Get-ChildItem -File -Recurse $sourcePath
# Create Utf8 Encoding Object To Write Log Content
$Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False
$newLine = [Environment]::NewLine
function OutPutFiles {
    param (
        $Source, $Target
    )
    if (!(Test-Path $Target)) {
        Write-Host "Crating $Target"
        New-Item -Force  $Target
    }

    Write-Host "Copying $Source To $Target"
    Copy-Item -Force $Source $Target
    Write-Host "Copied $Source To $Target`n"
}

function AppendLogText {
    param (
        $logFile,
        $text
    )
    [System.IO.File]::AppendAllText($logFile, "$text$newLine", $Utf8NoBomEncoding) 
}

foreach ($file in $files) {
    $tempFile = $file.fullName.Replace($sourcePath, $targetPath)
    if (Test-Path $tempFile) {
        
        $exportFile = $tempFile.Replace($targetPath, $backUpPath)
        # Copy File To Temp File
        $parent = Split-Path -Path $exportFile -Parent
        If (!(Test-Path $parent)) {
            # Create Folder Structure
            New-Item -Path $parent -ItemType Directory    
        }
        Write-Host "Copying...$tempFile"
        # -Force Overwrite Exist File
        Copy-Item -Force $tempFile  $exportFile
        Write-Host "Copied...$exportFile"
        AppendLogText $logFile $tempFile
    }
    else {
        $message = [string]::Format("New File...{0}", $file.fullName)
        Write-Host $message
        AppendLogText $logNewFile $tempFile       
    }
    OutPutFiles $file.FullName $tempFile
}

Write-Host "`nProgram Finished...`n"
# If running in the console, wait for input before closing.
if ($Host.Name -eq "ConsoleHost") {
    Write-Host "Press any key to continue..."
    $Host.UI.RawUI.FlushInputBuffer()   # Make sure buffered input doesn't "press a key" and skip the ReadKey().
    $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyUp") > $null
}
