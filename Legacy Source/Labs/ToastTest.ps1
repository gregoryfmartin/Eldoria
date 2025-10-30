using namespace System

Set-StrictMode -Version Latest

Import-Module BurntToast

$Bar1 = New-BTProgressBar -Title 'TitleVar1' -Status 'StatusVar1' -Value 'ValueVar1'
$Bar2 = New-BTProgressBar -Title 'TitleVar2' -Status 'StatusVar2' -Value 'ValueVar2'

#$Bar1 = New-BTProgressBar -Title 'TitleVar1' -Value 'ValueVar1'
#$Bar2 = New-BTProgressBar -Title 'TitleVar2' -Value 'ValueVar2'


$Id = 'EldoriaBattleToast'

$Text = '[PLAYERNAME] v [ENEMYNAME]'

$DataBinding = @{
    'TitleVar1'  = 'A Title'
    'StatusVar1' = ''
    'ValueVar1'  = 0
    'TitleVar2'  = 'B Title'
    'StatusVar2' = ''
    'ValueVar2'  = 0
}

$SuperSplat = @{
    Text             = $Text
    UniqueIdentifier = $Id
    ProgressBar      = $Bar1, $Bar2
    DataBinding      = $DataBinding
}

New-BurntToastNotification @SuperSplat
