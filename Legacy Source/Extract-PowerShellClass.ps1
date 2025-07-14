<#
.SYNOPSIS
    Extracts PowerShell class definitions into separate .ps1 files.

.DESCRIPTION
    This script reads a specified PowerShell file, identifies all class definitions
    whose names start with "BE", extracts the full text of each class (including
    its base class), and then saves each class into a new .ps1 file named after the class.
    The output files are are organized into subdirectories named after their base class.
    Each output file will start with a predefined header.

.PARAMETER FilePath
    The path to the PowerShell file containing the class definitions.

.EXAMPLE
    .\Extract-Classes.ps1 -FilePath "C:\Scripts\MyModule.psm1"

.NOTES
    Author: Gemini
    Date: July 10, 2025
    Version: 1.3 - Added a predefined header to each output file.
#>

param (
    [Parameter(Mandatory=$true)]
    [string]$FilePath
)

function Extract-PowerShellClass {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$InputFilePath
    )

    Write-Host "Processing file: $($InputFilePath)"

    # Check if the file exists
    if (-not (Test-Path $InputFilePath -PathType Leaf)) {
        Write-Error "File not found: $($InputFilePath)"
        return
    }

    # Read the entire content of the file
    $fileContent = Get-Content $InputFilePath -Raw

    # Regular expression to find class definitions.
    # It captures:
    # 1. The full class definition (including 'class ClassName : BaseClass { ... }')
    # 2. The class name (now specifically starting with "BE")
    # 3. The base class name
    # The regex is designed to be non-greedy and case-insensitive.
    $classRegex = [regex]'(?smi)^(\s*class\s+(BE[a-zA-Z0-9_]*)\s*:\s*([a-zA-Z_][a-zA-Z0-9_]*)\s*\{.*?\n\})'

    $matches = $classRegex.Matches($fileContent)

    if ($matches.Count -eq 0) {
        Write-Warning "No class definitions starting with 'BE' found in $($InputFilePath)."
        return
    }

    foreach ($match in $matches) {
        $fullClassText = $match.Groups[1].Value.Trim()
        $className = $match.Groups[2].Value
        $baseClassName = $match.Groups[3].Value

        Write-Host "Found class: $($className) inheriting from: $($baseClassName)"
        
        # Define the header text to be written at the beginning of each file
        $fileHeader = @"
using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE $($className.ToUpper())
#
###############################################################################


"@

        # Determine the base directory for the output files (parent of the input file)
        $outputBaseDirectory = Split-Path $InputFilePath -Parent

        # Create the new directory path based on the base class name
        $outputDirectory = Join-Path $outputBaseDirectory $baseClassName

        # Ensure the output directory exists. -Force creates parent directories if they don't exist.
        try {
            New-Item -ItemType Directory -Path $outputDirectory -Force | Out-Null
            Write-Host "Ensured directory exists: $($outputDirectory)"
        }
        catch {
            Write-Error "Failed to create directory '$($outputDirectory)': $($_.Exception.Message)"
            continue # Skip to the next class if directory creation fails
        }

        # Create the new file name
        $outputFileName = "$($className).ps1"
        # Join the new directory path with the file name
        $outputPath = Join-Path $outputDirectory $outputFileName

        # Combine the header and the class text
        $contentToWrite = $fileHeader + $fullClassText

        # Write the combined content to the new file
        try {
            Set-Content -Path $outputPath -Value $contentToWrite -Force
            Write-Host "Successfully wrote class '$($className)' to: $($outputPath)"
        }
        catch {
            Write-Error "Failed to write file '$($outputPath)': $($_.Exception.Message)"
        }
    }
}

# Call the function with the provided FilePath
Extract-PowerShellClass -InputFilePath $FilePath
