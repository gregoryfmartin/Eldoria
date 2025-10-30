using namespace System

Set-StrictMode -Version Latest

Class Toast {
    [String]$Text
    [String]$Id
    [Microsoft.Toolkit.Uwp.Notifications.AdaptiveProgressBar[]]$HealthBars
    [Hashtable]$Bindable
    
    Toast() {
        $this.Text = ''
        $this.Id = ''
        $this.HealthBars = @()
        $this.Bindable = @{}
    }
    
    Toast(
        [String]$Text,
        [String]$Id,
        [Microsoft.Toolkit.Uwp.Notifications.AdaptiveProgressBar[]]$HealthBars,
        [Hashtable]$Bindable
    ) {
        $this.Text = $Text
        $this.Id = $Id
        $this.HealthBars = $HealthBars
        $this.Bindable = $Bindable
    }
    
    [Void]CreateToast() {
        $S = @{
            Text = $this.Text
            UniqueIdentifier = $this.Id
            ProgressBar = $this.HealthBars
            DataBinding = $this.Bindable
        }
        
        New-BurntToastNotification @S
    }
    
    [Void]Butter() {
        Update-BTNotification -UniqueIdentifier $this.Id -DataBinding $this.Bindable
    }
}


[Toast]$A = [Toast]::new(
    'Some Text',
    'Some Id',
    @(
        (New-BTProgressBar -Title 'A Title' -Status ' ' -Value 0),
        (New-BTProgressBar -Title 'B Title' -Status ' ' -Value 0)
    ),
    @{}
)

$A.CreateToast()
