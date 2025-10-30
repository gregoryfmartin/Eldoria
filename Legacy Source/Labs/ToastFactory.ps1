using namespace System
using namespace System.Collections.Generic

Set-StrictMode -Version Latest

Class Toast {
    [String]$Text
    [String]$Id
    [Microsoft.Toolkit.Uwp.Notifications.AdaptiveProgressBar[]]$HealthBars
    [Hashtable]$Bindable
    
    Toast() {
        $this.Text       = ''
        $this.Id         = ''
        $this.HealthBars = @()
        $this.Bindable   = @{}
    }
    
    Toast(
        [String]$Text,
        [String]$Id,
        [Microsoft.Toolkit.Uwp.Notifications.AdaptiveProgressBar[]]$HealthBars,
        [Hashtable]$Bindable
    ) {
        $this.Text       = $Text
        $this.Id         = $Id
        $this.HealthBars = $HealthBars
        $this.Bindable   = $Bindable
    }
    
    [Void]CreateToast() {
        $S = @{
            Text             = $this.Text
            UniqueIdentifier = $this.Id
            ProgressBar      = $this.HealthBars
            DataBinding      = $this.Bindable
        }
        
        New-BurntToastNotification @S
    }
    
    [Void]Butter() {
        Update-BTNotification -UniqueIdentifier $this.Id -DataBinding $this.Bindable
    }
}

Class Toaster {
    [List[Toast]]$Loaf
    
    Toaster() {
        $this.Loaf = [List[Toast]]::new()
    }
    
    Toaster(
        [Toast[]]$NewLoaf
    ) {
        $this.Loaf = [List[Toast]]::new()
        
        If($NewLoaf) {
            Foreach($Bread in $NewLoaf) {
                $this.Loaf.Add($Bread)
            }
        }
    }
    
    [Void]BurnAPieceOfToast(
        [String]$SliceId
    ) {
        Foreach($Slice in $this.Loaf) {
            If($Slice.Id -EQ $SliceId) {
                $Slice.CreateToast()
            }
        }
    }
    
    [Void]BurnSomeToast(
        [String[]]$SliceIds
    ) {
        Foreach($Id in $SliceIds) {
            $this.BurnAPieceOfToast($Id)
        }
    }
    
    [Void]ButterAPieceOfToast(
        [String]$SliceId,
        [Hashtable]$Binder
    ) {
        Foreach($Slice in $this.Loaf) {
            If($Slice.Id -EQ $SliceId) {
                $Slice.Bindable = $Binder
                $Slice.Butter()
            }
        }
    }
}


[Toaster]$A = [Toaster]::new(
    @(
        [Toast]@{
            Text       = 'Some Text'
            Id         = 'Some Id'
            HealthBars = @(
                (New-BTProgressBar -Title 'ATitle' -Status 'AStatus' -Value 'AValue'),
                (New-BTProgressBar -Title 'BTitle' -Status 'BStatus' -Value 'BValue')
            )
            Bindable = @{
                'ATitle'  = 'Some Title'
                'BTitle'  = 'Another Title'
                'AStatus' = 'Some Status'
                'BStatus' = 'Another Status'
                'AValue'  = 0.0
                'BValue'  = 0.0
            }
        },
        [Toast]@{
            Text       = 'Moar Text'
            Id         = 'Some Id 2'
            HealthBars = @(
                (New-BTProgressBar -Title 'ATitle' -Status ' ' -Value 0),
                (New-BTProgressBar -Title 'BTitle' -Status ' ' -Value 0)
            )
            Bindable = @{}
        }
    )
)

$A.BurnAPieceOfToast('Some Id')
[Float]$Probe = 0
[Int]$Ticks   = 0
[Int]$Skip    = 5


# THE PROGRESS BAR VALUE IS FUCKING NORMALIZED!!

While($Probe -NE 1.0) {
    $Ticks++
    If($Ticks -GE (10000000 / $Skip)) {
        $Ticks = 0
        $Probe = $Probe + 0.01
        $A.ButterAPieceOfToast(
            'Some Id',
            @{
                'AStatus' = "$(Get-Random -Minimum 1 -Maximum 50)"
                'BStatus' = "$(Get-Random -Minimum 1 -Maximum 50)"
                'AValue'  = $Probe
                'BValue'  = $Probe
            }            
        )
    }
}
