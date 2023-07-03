Add-Type -AssemblyName PresentationCore

Class AudioFileDescriptor {
    [String]$Name
    [String]$Path
    [Boolean]$Loop
}

Class AFDEmpty : AudioFileDescriptor {
    AFDEmpty() : base() {
        $this.Name = ''
        $this.Path = ''
        $this.Loop = $false
    }
}

Class AudioPlayer {
    [AudioFileDescriptor]$Descriptor
    [System.Windows.Media.MediaPlayer]$Player
}

Class APEmpty : AudioPlayer {
    APEmpty() : base() {
        $this.Descriptor = [AFDEmpty]::new()
        $this.Player     = $null
    }
}

Class AudioManager {
    Static [Double]$BgmDefaultVolume = 0.5
    Static [Double]$SfxDefaultVolume = 0.5
    
    Static [String]$BgmKeyBattleThemeA         = 'Battle Theme A'
    Static [String]$SfxKeyBAActionDisabled     = 'BA Action Disabled'
    Static [String]$SfxKeyBAFireStrike0001     = 'BA Fire Strike 0001'
    Static [String]$SfxKeyBAMissFail           = 'BA Miss Fail'
    Static [String]$SfxKeyBAPhysicalStrike0001 = 'BA Physical Strike 0001'
    Static [String]$SfxKeyUIChevronMove        = 'UI Chevron Move'
    Static [String]$SfxKeyUISelectionValid     = 'UI Selection Valid'

    [Hashtable]$BgmLibrary
    [Hashtable]$SfxLibrary
    [AudioFileDescriptor]$BgmCurrentlyPlaying
    [AudioFileDescriptor]$SfxCurrentlyPlaying
    [Double]$BgmVolume
    [Double]$SfxVolume
    [ScriptBlock]$LoopingHandler

    AudioManager() {
        $this.BgmLibrary          = @{}
        $this.SfxLibrary          = @{}
        $this.BgmCurrentlyPlaying = [AFDEmpty]::new()
        $this.SfxCurrentlyPlaying = [AFDEmpty]::new()
        $this.BgmVolume           = [AudioManager]::BgmDefaultVolume
        $this.SfxVolume           = [AudioManager]::SfxDefaultVolume
        $this.LoopingHandler      = {
            Param(
                $Sender,
                $EventArgs
            )

            # TEST CODE
            Write-Host "Sender is $($Sender.GetType())."
            Write-Host "EventArgs are $($EventArgs.GetType())."
        }

        $this.LoadBgmLibrary()
        $this.LoadSfxLibrary()
        $this.OpenBgmLibrary()
        $this.OpenSfxLibrary()
    }

    [Void]LoadBgmLibrary() {
        <#
        I had originally intended to loop through the contents of the BGM directory, but this makes it harder to map a key to
        a value, and I already know what the hell is in there anyway, so fuck it.
        #>
        $this.BgmLibrary[[AudioManager]::BgmKeyBattleThemeA] = [AudioPlayer]@{
            Descriptor = [AudioFileDescriptor]@{
                Name = [AudioManager]::BgmKeyBattleThemeA
                Path = "$(Get-Location)\..\Assets\BGM\$([AudioManager]::BgmKeyBattleThemeA).wav"
                Loop = $true
            }
            Player = [System.Windows.Media.MediaPlayer]::new()
        }
    }

    [Void]LoadSfxLibrary() {
        <#
        I had originally intended to loop through the contents of the SFX directory, but this makes it harder to map a key to
        a value, and I already know what the hell is in there anyway, so fuck it.
        #>
        $this.SfxLibrary[[AudioManager]::SfxKeyBAActionDisabled] = [AudioPlayer]@{
            Descriptor = [AudioFileDescriptor]@{
                Name = [AudioManager]::SfxKeyBAActionDisabled
                Path = "$(Get-Location)\..\Assets\SFX\$([AudioManager]::SfxKeyBAActionDisabled).wav"
                Loop = $false
            }
            Player = [System.Windows.Media.MediaPlayer]::new()
        }
        $this.SfxLibrary[[AudioManager]::SfxKeyBAFireStrike0001] = [AudioPlayer]@{
            Descriptor = [AudioFileDescriptor]@{
                Name = [AudioManager]::SfxKeyBAFireStrike0001
                Path = "$(Get-Location)\..\Assets\SFX\$([AudioManager]::SfxKeyBAFireStrike0001).wav"
                Loop = $false
            }
            Player = [System.Windows.Media.MediaPlayer]::new()
        }
        $this.SfxLibrary[[AudioManager]::SfxKeyBAMissFail] = [AudioPlayer]@{
            Descriptor = [AudioFileDescriptor]@{
                Name = [AudioManager]::SfxKeyBAMissFail
                Path = "$(Get-Location)\..\Assets\SFX\$([AudioManager]::SfxKeyBAMissFail).wav"
                Loop = $false
            }
            Player = [System.Windows.Media.MediaPlayer]::new()
        }
        $this.SfxLibrary[[AudioManager]::SfxKeyBAPhysicalStrike0001] = [AudioPlayer]@{
            Descriptor = [AudioFileDescriptor]@{
                Name = [AudioManager]::SfxKeyBAPhysicalStrike0001
                Path = "$(Get-Location)\..\Assets\SFX\$([AudioManager]::SfxKeyBAPhysicalStrike0001).wav"
                Loop = $false
            }
            Player = [System.Windows.Media.MediaPlayer]::new()
        }
        $this.SfxLibrary[[AudioManager]::SfxKeyUIChevronMove] = [AudioPlayer]@{
            Descriptor = [AudioFileDescriptor]@{
                Name = [AudioManager]::SfxKeyUIChevronMove
                Path = "$(Get-Location)\..\Assets\SFX\$([AudioManager]::SfxKeyUIChevronMove).wav"
                Loop = $false
            }
            Player = [System.Windows.Media.MediaPlayer]::new()
        }
        $this.SfxLibrary[[AudioManager]::SfxKeyUISelectionValid] = [AudioPlayer]@{
            Descriptor = [AudioFileDescriptor]@{
                Name = [AudioManager]::SfxKeyUISelectionValid
                Path = "$(Get-Location)\..\Assets\SFX\$([AudioManager]::SfxKeyUISelectionValid).wav"
                Loop = $false
            }
            Player = [System.Windows.Media.MediaPlayer]::new()
        }
    }

    [Void]OpenBgmLibrary() {
        $b = $this.LoopingHandler

        Foreach($a in $this.BgmLibrary.Values) {
            $a.Player.Open($a.Descriptor.Path)
            $a.Player.Add_MediaEnded($b)
        }
    }

    [Void]OpenSfxLibrary() {
        $b = $this.LoopingHandler

        Foreach($a in $this.SfxLibrary.Values) {
            $a.Player.Open($a.Descriptor.Path)
            $a.Player.Add_MediaEnded($b)
        }
    }

    [Void]PlayBgm(
        [String]$BgmName
    ) {
        If($BgmName -IN $this.BgmLibrary.Keys) {
            $this.BgmCurrentlyPlaying = $this.BgmLibrary[$BgmName].Descriptor
            $this.BgmLibrary[$BgmName].Player.Play()
        }
    }

    [Void]PlaySfx(
        [String]$SfxName
    ) {
        If($SfxName -IN $this.SfxLibrary.Keys) {
            $this.SfxCurrentlyPlaying = $this.SfxLibrary[$SfxName].Descriptor
            $this.SfxLibrary[$SfxName].Player.Play()
        }
    }

    [Void]StopBgm() {
        $this.BgmCurrentlyPlaying = [AFDEmpty]::new()
        $this.BgmLibrary[$this.BgmCurrentlyPlaying.Name].Player.Stop()
    }

    [Void]StopSfx() {
        $this.SfxCurrentlyPlaying = [AFDEmpty]::new()
        $this.SfxLibrary[$this.SfxCurrentlyPlaying.Name].Player.Stop()
    }

    [Void]Dispose() {
        $this.StopBgm()
        $this.StopSfx()

        Foreach($a in $this.BgmLibrary.Values) {
            $a.Player.Dispose()
        }
        Foreach($a in $this.SfxLibrary.Values) {
            $a.Player.Dispose()
        }
    }
}

[AudioManager]$AudioMan = [AudioManager]::new()
$AudioMan.PlaySfx([AudioManager]::SfxKeyBAFireStrike0001)