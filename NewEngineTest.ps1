 # This is meant as a test for the NewEngine module

Import-Module '.\NewEngine.psm1'

Clear-Host

# 9.18.2022:0901 PASS
#Write-GfmStatusWindow

# 9.18.2022:0902 FAIL
# 9.18.2022:0918 PASS
#Write-GfmSceneWindow

# 9.18.2022:0903 FAIL
# 9.18.2022:2220 PASS
#Write-GfmMessageWindow

# 10.31.2022:2053
#Write-GfmCommandWindow

# 9.18.2022:0905 PASS
#Write-GfmPositionalString -Coordinates $([System.Management.Automation.Host.Coordinates]::new(10, 10)) `
#    -Message "Hello, world!" -ForegroundColor 'Red'


# 9.18.2022:0907 PASS
#Write-GfmTtyString -Message "Hello, World!" -ForegroundColor 'Blue' -TypeSpeed SuperSlow

# 9.18.2022:0908 PASS
#Write-GfmPositionalTtyString -Coordinates $([System.Management.Automation.Host.Coordinates]::new(10, 20)) `
#    -Message 'Hello, world, again!' -ForegroundColor 'Yellow'

# Scene Test
# 9.18.2022:2256 PASS
#Test-GfmPlayScreen

#While(1) {
#    Read-GfmUserCommandInput
    # $PressedKey = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    # If ($PressedKey.VirtualKeyCode -EQ 65) {
    #     Write-GfmMessageWindowMessage `
    #         -Message "$(Get-Random -Minimum 5 -Maximum 500) $(Get-Random -Minimum 5 -Maximum 500) $(Get-Random -Minimum 5 -Maximum 500) $(Get-Random -Minimum 5 -Maximum 500) $(Get-Random -Minimum 5 -Maximum 500) $(Get-Random -Minimum 5 -Maximum 500)" `
    #         -Teletype
    # }
#}

Start-GfmGame
