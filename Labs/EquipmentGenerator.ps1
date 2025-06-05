Param(
    [String]$DataPath,
    [String]$EquipmentType,
    [String]$OutputFile
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
                    'Weapon'    { 'BEWeapon'; Break }
                    'Helmet'    { 'BEHelmet'; Break }
                    'Armor'     { 'BEArmor'; Break }
                    'Pauldron'  { 'BEPauldron'; Break }
                    'Gauntlets' { 'BEGauntlets'; Break }
                    'Greaves'   { 'BEGreaves'; Break }
                    'Boots'     { 'BEBoots'; Break }
                    'Jewelry'   { 'BEJewelry'; Break }
                    'Cape'      { 'BECape'; Break }
                    Default     { 'BEWeapon'; Break }
                }
            ) {",
            "`tBE$($Row.Name -REPLACE "[\s'-]+", '')() : base() {",
            "`t`t`$this.Name               = '$($Row.Name -REPLACE "'", "''")'",
            "`t`t`$this.MapObjName         = '$(($Row.Name -REPLACE "[\s'-]+", '').ToLower())'",
            "`t`t`$this.PurchasePrice      = $($Row.'Purchase Price')",
            "`t`t`$this.SellPrice          = $($Row.'Sell Price')",
            "`t`t`$this.TargetStats        = $(
                # I'LL LIKELY NEED TO ADD MORE LOGIC FOR DIFFERENT KINDS OF EQUIPMENT TYPES
                If($EquipmentType -EQ 'Weapon') {
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
                } Else {
                    $Data = '@{ '
                    If($Row.'Defense Power' -GT 0 -AND $Row.'Magic Defense Power' -GT 0) {
                        $Data += "[StatId]::Defense = $($Row.'Defense Power'); [StatId]::MagicDefense = $($Row.'Magic Defense Power')"
                    } Else {
                        If($Row.'Defense Power' -GT 0) {
                            $Data += "[StatId]::Defense = $($Row.'Defense Power')"
                        } Elseif($Row.'Magic Defense Power' -GT 0) {
                            $Data += "[StatId]::MagicDefense = $($Row.'Magic Defense Power')"
                        }
                    }
                    $Data += ' }'
                    $Data
                }
            )",
            "`t`t`$this.CanAddToInventory  = `$true",
            "`t`t`$this.ExamineString      = '$($Row.Description -REPLACE "'", "''")'",
            "`t`t`$this.PlayerEffectString = `"$(
                # I'LL LIKELY NEED TO ADD MORE LOGIC FOR DIFFERENT KINDS OF EQUIPMENT TYPES
                If($EquipmentType -EQ 'Weapon') {
                    If($Row.'Attack Power' -GT 0 -AND $Row.'Magic Attack Power' -GT 0) {
                        '+$($this.TargetStats[[StatId]::Attack]) ATK, +$($this.TargetStats[[StatId]::MagicAttack]) MAT'
                    } Else {
                        If($Row.'Attack Power' -GT 0) {
                            '+$($this.TargetStats[[StatId]::Attack]) ATK'
                        } Else {
                            '+$($this.TargetStats[[StatId]::MagicAttack]) MAT'
                        }
                    }
                } Else {
                    If($Row.'Defense Power' -GT 0 -AND $Row.'Magic Defense Power' -GT 0) {
                        '+$($this.TargetStats[[StatId]::Defnse]) DEF, +$($this.TargetStats[[StatId]::MagicDefense]) MDF'
                    } Else {
                        If($Row.'Defense Power' -GT 0) {
                            '+$($this.TargetStats[[StatId]::Defense]) DEF'
                        } Else {
                            '+$($this.TargetStats[[StatId]::MagicDefense]) MDF'
                        }
                    }
                }
            )`"",
            "`t`t`$this.TargetGender       = $(
                If(($Row | Get-Member -Name 'Gender')) {
                    Switch($Row.Gender) {
                        'Unisex' { '[Gender]::Unisex'; Break }
                        'Male'   { '[Gender]::Male'; Break }
                        'Female' { '[Gender]::Female'; Break }
                        Default  { '[Gender]::Unisex'; Break }
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
        Start-Sleep -Seconds 1 # Stops a race condition for file access that can prevent some entries from being written; makes this GAWD AWFUL SLOW!
        $Itr++
    }
}


