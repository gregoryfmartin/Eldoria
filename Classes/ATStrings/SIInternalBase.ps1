using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# SI INTERNAL BASE
#
# A SPECIALIZATION OF SCENE IMAGE THAT ADDS COLOR MAP DATA.
#
###############################################################################

Class SIInternalBase : SceneImage {
    [ATBackgroundColor24[]]$ColorMap

    SIInternalBase() : base() {
        $this.ColorMap = New-Object 'ATBackgroundColor24[]' ([Int32](([Int32]([SceneImage]::Width)) * ([Int32]([SceneImage]::Height))))
    }

    SIInternalBase(
        [String]$JsonConfigPath
    ) : base() {
        Write-Progress `
            -Activity 'Creating Scene Images' `
            -Id 2 `
            -CurrentOperation "Creating $([System.IO.Path]::GetFileNameWithoutExtension($JsonConfigPath))" `
            -PercentComplete (($Script:SceneImagesLoaded / $Script:SceneImagesToLoad) * 100)

        [Hashtable]$JsonData = @{}
        $this.ColorMap = New-Object 'ATBackgroundColor24[]' ([Int32](([Int32]([SceneImage]::Width)) * ([Int32]([SceneImage]::Height))))

        If($(Test-Path $JsonConfigPath) -EQ $true) {
            $JsonData = Get-Content -Raw $JsonConfigPath | ConvertFrom-Json -AsHashtable

            # THIS JSON DATA WOULD CONTAIN ONLY ONE ELEMENT CALLED COLORDATA WHICH IS A SINGLE ARRAY
            # THAT CONTAINS EITHER A STRING, WHICH WOULD BE MAPPED TO A SPECIFIC COLOR DEFINED ABOVE,
            # OR AN ARRAY OF R, G, B VALUES WHICH WOULD CREATE A CUSTOM COLOR.
            [Int]$A = 0
            Foreach($B in $JsonData['ColorData']) {
                If($B -IS [String]) {
                    [String]$C = [String]::Format("CC{0}24", $B)
                    $this.ColorMap[$A] = New-Object "$($C)"
                } Elseif($B -IS [Array]) {
                    $this.ColorMap[$A] = [ATBackgroundColor24]::new([ConsoleColor24]::new($B[0], $B[1], $B[2]))
                }
                $A++
            }

            $this.CreateSceneImageATString($this.ColorMap)
            $this.ColorMap = $null

            $Script:SceneImagesLoaded++
            Write-Progress `
                -Activity 'Creating Scene Images' `
                -Id 2 `
                -CurrentOperation "Creating $([System.IO.Path]::GetFileNameWithoutExtension($JsonConfigPath))" `
                -PercentComplete (($Script:SceneImagesLoaded / $Script:SceneImagesToLoad) * 100)
        }
    }
}
