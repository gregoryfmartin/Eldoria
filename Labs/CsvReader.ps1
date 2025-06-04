Param(
    [String]$DataPath,
    [String]$EquipmentType,
    [String]$OutputFile,
    [Switch]$UseGenders
)

Set-StrictMode -Version Latest
$PSStyle.Progress.View = 'Classic'

Trap { "`e[38;2;255;0;0m`e[5mFUCK!`e[m" }

$Itr     = 0
$CsvData = Import-Csv -Path $DataPath

If($CsvData.Count -GT 0) {
    Foreach($Row in $CsvData) {
        Write-Progress `
            -Activity 'Writing Class Data' `
            -Id 1 `
            -CurrentOperation "Writing class $($Row.Name)" `
            -PercentComplete (($Itr / $CsvData.Count) * 100)

        $ClassStringData = @(
            "Class BE$($Row.Name -REPLACE "[\s']+", '') : $(
                Switch($EquipmentType) {
                    'Weapon'    { 'BEWeapon' }
                    'Helmet'    { 'BEHelmet' }
                    'Armor'     { 'BEArmor' }
                    'Pauldron'  { 'BEPauldron' }
                    'Gauntlets' { 'BEGauntlets' }
                    'Greaves'   { 'BEGreaves' }
                    'Boots'     { 'BEBoots' }
                    'Jewelry'   { 'BEJewelry' }
                    'Cape'      { 'BECape' }
                    Default     { 'BEWeapon' }
                }
            ) {",
            "`tBE$($Row.Name -REPLACE "[\s']+", '')() : base() {",
            "`t`t`$this.Name = '$($Row.Name -REPLACE "'", "''")'",
            "`t`t`$this.MapObjName = '$(($Row.Name -REPLACE "[\s']+", '').ToLower())'",
            "`t`t`$this.PurchasePrice = $($Row.'Purchase Price')",
            "`t`t`$this.SellPrice = $($Row.'Sell Price')",
            "`t`t`$this.TargetStats = $(
                $Data = '@{ '
                If($Row.'Attack Power' -GT 0 -AND $Row.'Magic Attack Power' -GT 0) {
                    $Data += "[StatId]::Attack = $($Row.'Attack Power'); [StatId]::MagicAttack = $($Row.'Magic Attack Power')"
                } Else {
                    If($Row.'Attack Power' -GT 0) {
                        $Data += "[StatId]::Attack = $($Row.'Attack Power')"
                    } Elseif($Row.'Magic Attack Power' -GT 0) {
                        $Data += "[StatId]::MagicAttack = $($Row.'Magic Attack Power')"
                    }
                }
                $Data += ' }'
                $Data
            )",
            "`t`t`$this.CanAddToInventory = `$true",
            "`t`t`$this.ExamineString = '$($Row.Description -REPLACE "'", "''")'",
            "`t`t`$this.PlayerEffectString = `"$(
                If($Row.'Attack Power' -GT 0 -AND $Row.'Magic Attack Power' -GT 0) {
                    '+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT'
                } Else {
                    If($Row.'Attack Power' -GT 0) {
                        '+$($this.TargetStats[[StatId]::Attack]) ATK'
                    } Else {
                        '+$($this.TargetStats[[StatId]::MagicAttack]) MAT'
                    }
                }
            )`"",
            "`t`t`$this.TargetGender = $(
                If(($Row | Get-Member -Name 'Gender')) {
                    Switch($Row.Gender) {
                        { 'Unisex' } { '[Gender]::Unisex' }
                        { 'Male' }   { '[Gender]::Male' }
                        { 'Female' } { '[Gender]::Female' }
                        Default { '[Gender]::Unisex' }
                    }
                } Else {
                    '[Gender]::Unisex'
                }
            )"
            "`t}",
            '}',
            ''
        )
        Add-Content -Path $OutputFile -Value $ClassStringData
        Start-Sleep -Seconds 1
        $Itr++
    }
}


