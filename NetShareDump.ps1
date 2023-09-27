param (
    [string]$inputFile,
    [string]$outPath,
    [System.Collections.ArrayList]$extensions,
    [switch]$listOnly,
    [switch]$verbose
)

# Create outputh directory
if (-not (Test-Path -Path $outPath)) {
    New-Item -Path $outPath -ItemType Directory | Out-Null
}

# Read input file
$shareList = Get-Content -Path $inputFile

$timestamp = Get-Date -UFormat "%Y-%m-%d_%H-%m-%S"

# Recursive function to find and copy files
function BrowseAndFind {
    param (
        [string]$Path
    )
    Write-Host "[+] PROCESSING $Path" -ForegroundColor Yellow
    # Find files matching extensions filter
    $Files = Get-ChildItem -Path $Path -File -ErrorAction Ignore | Where-Object {$_.Extension -in $extensions}
    foreach ($File in $Files) {
        # If list only, output file name in a text file
        if ($listOnly) {
            Write-Host "[!] File found : $($File.FullName)" -ForegroundColor Green
            $File.FullName >> $outPath\$timestamp.txt
        } 
        else 
        {
            # Check if file is readable first
            try 
            {
                $canRead = $true
                [System.IO.File]::OpenRead($File.FullName).Close()
            }
            catch 
            {
                $canRead = $false
            }
            if($canRead)
            {
                # Copy file to destination folder
                Get-Item $File.FullName | Copy-Item -ErrorAction SilentlyContinue -Destination {
                    $Destination = Join-Path $outPath $_.DirectoryName.TrimStart("\")
                    If(!(test-path -PathType container $Destination))
                    {
                        New-Item -ItemType Directory -Path $Destination
                    }
                    $Destination.ToString()
                    if($Verbose) { Write-Host "[!] Copying $($File.FullName) to $($Destination)" -ForegroundColor Green }
                }   
            }    
        }
    }
    # Recursive call for subdirectories
    $SousRepertoires = Get-ChildItem -Path $Path -Directory -ErrorAction Ignore
    foreach ($SousRepertoire in $SousRepertoires) {
        BrowseAndFind -Path $SousRepertoire.FullName
    }
}

# Main job - Do stuff for each UNC path in the list
foreach ($Share in $shareList) {
    if (Test-Path -Path $Share -PathType Container) {
        Write-Host "[+] PROCESSING $Share" -ForegroundColor Blue
        BrowseAndFind -Path $Share
    } else {
        Write-Host "[X] ERROR - $Share is not a valid share" -ForegroundColor Red
    }
}
