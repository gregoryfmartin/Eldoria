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
            "`tBE$($Row.Name -REPLACE "[\s'\-]+", '')() : base() {",
            "`t`t`$this.Name               = '$($Row.Name -REPLACE "'", "''")'",
            "`t`t`$this.MapObjName         = '$(($Row.Name -REPLACE "[\s'\-]+", '').ToLower())'",
            "`t`t`$this.PurchasePrice      = $($Row.'Purchase Price')",
            "`t`t`$this.SellPrice          = $($Row.'Sell Price')",
            "`t`t`$this.TargetStats        = $(
                $Data = "@{`n"

                Switch($EquipmentType) {
                    'Weapon' {
                        If($Row.'Attack Power' -GT 0) {
                            $Data += "`t`t`t[StatId]::Attack = $($Row.'Attack Power')`n"
                        }
                        If($Row.'Magic Attack Power' -GT 0) {
                            $Data += "`t`t`t[StatId]::MagicAttack = $($Row.'Magic Attack Power')`n"
                        }

                        Break
                    }
                    'Helmet' {
                        If($Row.'Defense Power' -GT 0) {
                            $Data += "`t`t`t[StatId]::Defense = $($Row.'Defense Power')`n"
                        }
                        If($Row.'Magic Defense Power' -GT 0) {
                            $Data += "`t`t`t[StatId]::MagicDefense = $($Row.'Magic Defense Power')`n"
                        }
                        
                        Break
                    }
                    'Armor' {
                        If($Row.'Defense Power' -GT 0) {
                            $Data += "`t`t`t[StatId]::Defense = $($Row.'Defense Power')`n"
                        }
                        If($Row.'Magic Defense Power' -GT 0) {
                            $Data += "`t`t`t[StatId]::MagicDefense = $($Row.'Magic Defense Power')`n"
                        }
                        
                        Break
                    }
                    'Pauldron'  {
                        If($Row.'Defense Power' -GT 0) {
                            $Data += "`t`t`t[StatId]::Defense = $($Row.'Defense Power')`n"
                        }
                        If($Row.'Magic Defense Power' -GT 0) {
                            $Data += "`t`t`t[StatId]::MagicDefense = $($Row.'Magic Defense Power')`n"
                        }
                        
                        Break
                    }
                    'Gauntlets' {
                        If($Row.'Defense Power' -GT 0) {
                            $Data += "`t`t`t[StatId]::Defense = $($Row.'Defense Power')`n"
                        }
                        If($Row.'Magic Defense Power' -GT 0) {
                            $Data += "`t`t`t[StatId]::MagicDefense = $($Row.'Magic Defense Power')`n"
                        }
                        If($Row.Accuracy -GT 0) {
                            $Data += "`t`t`t[StatId]::Accuracy = $($Row.Accuracy)`n"
                        }
                        
                        Break
                    }
                    'Greaves' {
                        If($Row.'Defense Power' -GT 0) {
                            $Data += "`t`t`t[StatId]::Defense = $($Row.'Defense Power')`n"
                        }
                        If($Row.'Magic Defense Power' -GT 0) {
                            $Data += "`t`t`t[StatId]::MagicDefense = $($Row.'Magic Defense Power')`n"
                        }
                        If($Row.Speed -GT 0) {
                            $Data += "`t`t`t[StatId]::Speed = $($Row.Speed)`n"
                        }
                        
                        Break
                    }
                    'Boots' {
                        If($Row.'Defense Power' -GT 0) {
                            $Data += "`t`t`t[StatId]::Defense = $($Row.'Defense Power')`n"
                        }
                        If($Row.'Magic Defense Power' -GT 0) {
                            $Data += "`t`t`t[StatId]::MagicDefense = $($Row.'Magic Defense Power')`n"
                        }
                        If($Row.Speed -GT 0) {
                            $Data += "`t`t`t[StatId]::Speed = $($Row.Speed)`n"
                        }
                        
                        Break
                    }
                    'Jewelry' {
                        If($Row.'Attack Power' -GT 0) {
                            $Data += "`t`t`t[StatId]::Attack = $($Row.'Attack Power')`n"
                        }
                        If($Row.'Defense Power' -GT 0) {
                            $Data += "`t`t`t[StatId]::Defense = $($Row.'Defense Power')`n"
                        }
                        If($Row.'Magic Attack Power' -GT 0) {
                            $Data += "`t`t`t[StatId]::MagicAttack = $($Row.'Magic Attack Power')`n"
                        }
                        If($Row.'Magic Defense Power' -GT 0) {
                            $Data += "`t`t`t[StatId]::MagicDefense = $($Row.'Magic Defense Power')`n"
                        }
                        If($Row.Speed -GT 0) {
                            $Data += "`t`t`t[StatId]::Speed = $($Row.Speed)`n"
                        }
                        If($Row.Luck -GT 0) {
                            $Data += "`t`t`t[StatId]::Luck = $($Row.Luck)`n"
                        }
                        If($Row.Accuracy -GT 0) {
                            $Data += "`t`t`t[StatId]::Accuracy = $($Row.Accuracy)`n"
                        }

                        Break
                    }
                    'Cape' {
                        If($Row.Speed -GT 0) {
                            $Data += "`t`t`t[StatId]::Speed = $($Row.Speed)`n"
                        }
                        If($Row.Luck -GT 0) {
                            $Data += "`t`t`t[StatId]::Luck = $($Row.Luck)`n"
                        }
                        If($Row.Accuracy -GT 0) {
                            $Data += "`t`t`t[StatId]::Accuracy = $($Row.Accuracy)`n"
                        }

                        Break
                    }
                }

                $Data += "`t`t}"
                $Data
            )",
            "`t`t`$this.CanAddToInventory  = `$true",
            "`t`t`$this.ExamineString      = '$($Row.Description -REPLACE "'", "''")'",
            "`t`t`$this.PlayerEffectString = `"$(
                $Data = ''

                Switch($EquipmentType) {
                    'Weapon'    {
                        If($Row.'Attack Power' -GT 0) {
                            $Data += '+$($this.TargetStats[[StatId]::Attack]) ATK'
                        }
                        If($Row.'Magic Attack Power' -GT 0) {
                            If($Data.Length -GT 0) {
                                $Data += '  +$($this.TargetStats[[StatId]::MagicAttack]) MAT'
                            } Else {
                                $Data += '+$($this.TargetStats[[StatId]::MagicAttack]) MAT'
                            }
                        }

                        Break
                    }
                    'Helmet'    {
                        If($Row.'Defense Power' -GT 0) {
                            $Data += '+$($this.TargetStats[[StatId]::Defense]) DEF'
                        }
                        If($Row.'Magic Defense Power' -GT 0) {
                            If($Data.Length -GT 0) {
                                $Data += '  +$($this.TargetStats[[StatId]::MagicDefense]) MDF'
                            } Else {
                                $Data += '+$($this.TargetStats[[StatId]::MagicDefense]) MDF'
                            }
                        }
                        
                        Break
                    }
                    'Armor'     {
                        If($Row.'Defense Power' -GT 0) {
                            $Data += '+$($this.TargetStats[[StatId]::Defense]) DEF'
                        }
                        If($Row.'Magic Defense Power' -GT 0) {
                            If($Data.Length -GT 0) {
                                $Data += '  +$($this.TargetStats[[StatId]::MagicDefense]) MDF'
                            } Else {
                                $Data += '+$($this.TargetStats[[StatId]::MagicDefense]) MDF'
                            }
                        }
                        
                        Break
                    }
                    'Pauldron'  {
                        If($Row.'Defense Power' -GT 0) {
                            $Data += '+$($this.TargetStats[[StatId]::Defense]) DEF'
                        }
                        If($Row.'Magic Defense Power' -GT 0) {
                            If($Data.Length -GT 0) {
                                $Data += '  +$($this.TargetStats[[StatId]::MagicDefense]) MDF'
                            } Else {
                                $Data += '+$($this.TargetStats[[StatId]::MagicDefense]) MDF'
                            }
                        }
                        
                        Break
                    }
                    'Gauntlets' {
                        If($Row.'Defense Power' -GT 0) {
                            $Data += '+$($this.TargetStats[[StatId]::Defense]) DEF'
                        }
                        If($Row.'Magic Defense Power' -GT 0) {
                            If($Data.Length -GT 0) {
                                $Data += '  +$($this.TargetStats[[StatId]::MagicDefense]) MDF'
                            } Else {
                                $Data += '+$($this.TargetStats[[StatId]::MagicDefense]) MDF'
                            }
                        }
                        If($Row.Accuracy -GT 0) {
                            If($Data.Length -GT 0) {
                                $Data += '  +$($this.TargetStats[[StatId]::Accuracy]) ACC'
                            } Else {
                                $Data += '+$($this.TargetStats[[StatId]::Accuracy]) ACC'
                            }
                        }
                        
                        Break
                    }
                    'Greaves'   {
                        If($Row.'Defense Power' -GT 0) {
                            $Data += '+$($this.TargetStats[[StatId]::Defense]) DEF'
                        }
                        If($Row.'Magic Defense Power' -GT 0) {
                            If($Data.Length -GT 0) {
                                $Data += '  +$($this.TargetStats[[StatId]::MagicDefense]) MDF'
                            } Else {
                                $Data += '+$($this.TargetStats[[StatId]::MagicDefense]) MDF'
                            }
                        }
                        If($Row.Speed -GT 0) {
                            If($Data.Length -GT 0) {
                                $Data += '  +$($this.TargetStats[[StatId]::Speed]) SPD'
                            } Else {
                                $Data += '+$($this.TargetStats[[StatId]::Speed]) SPD'
                            }
                        }
                        
                        Break
                    }
                    'Boots'     {
                        If($Row.'Defense Power' -GT 0) {
                            $Data += '+$($this.TargetStats[[StatId]::Defense]) DEF'
                        }
                        If($Row.'Magic Defense Power' -GT 0) {
                            If($Data.Length -GT 0) {
                                $Data += '  +$($this.TargetStats[[StatId]::MagicDefense]) MDF'
                            } Else {
                                $Data += '+$($this.TargetStats[[StatId]::MagicDefense]) MDF'
                            }
                        }
                        If($Row.Speed -GT 0) {
                            If($Data.Length -GT 0) {
                                $Data += '  +$($this.TargetStats[[StatId]::Speed]) SPD'
                            } Else {
                                $Data += '+$($this.TargetStats[[StatId]::Speed]) SPD'
                            }
                        }
                        
                        Break
                    }
                    'Jewelry'   {
                        If($Row.'Attack Power' -GT 0) {
                            $Data += '+$($this.TargetStats[[StatId]::Attack]) ATK'
                        }
                        If($Row.'Defense Power' -GT 0) {
                            If($Data.Length -GT 0) {
                                $Data += '  +$($this.TargetStats[[StatId]::Defense]) DEF'                                
                            } Else {
                                $Data += '+$($this.TargetStats[[StatId]::Defense]) DEF'
                            }
                        }
                        If($Row.'Magic Attack Power' -GT 0) {
                            If($Data.Length -GT 0) {
                                $Data += '  +$($this.TargetStats[[StatId]::MagicAttack]) MAT'
                            } Else {
                                $Data += '+$($this.TargetStats[[StatId]::MagicAttack]) MAT'
                            }
                        }
                        If($Row.'Magic Defense Power' -GT 0) {
                            If($Data.Length -GT 0) {
                                $Data += '  +$($this.TargetStats[[StatId]::MagicDefense]) MDF'
                            } Else {
                                $Data += '+$($this.TargetStats[[StatId]::MagicDefense]) MDF'
                            }
                        }
                        If($Row.Speed -GT 0) {
                            If($Data.Length -GT 0) {
                                $Data += '  +$($this.TargetStats[[StatId]::Speed]) SPD'
                            } Else {
                                $Data += '+$($this.TargetStats[[StatId]::Speed]) SPD'
                            }
                        }
                        If($Row.Luck -GT 0) {
                            If($Data.Length -GT 0) {
                                $Data += '  +$($this.TargetStats[[StatId]::Luck]) LCK'
                            } Else {
                                $Data += '+$($this.TargetStats[[StatId]::Luck]) LCK'
                            }
                        }
                        If($Row.Accuracy -GT 0) {
                            If($Data.Length -GT 0) {
                                $Data += '  +$($this.TargetStats[[StatId]::Accuracy]) ACC'                            
                            } Else {
                                $Data += '+$($this.TargetStats[[StatId]::Accuracy]) ACC'
                            }
                        }

                        Break
                    }
                    'Cape'      {
                        If($Row.Speed -GT 0) {
                            $Data += '+$($this.TargetStats[[StatId]::Speed]) SPD'
                        }
                        If($Row.Luck -GT 0) {
                            If($Data.Length -GT 0) {
                                $Data += '  +$($this.TargetStats[[StatId]::Luck]) LCK'
                            } Else {
                                $Data += '+$($this.TargetStats[[StatId]::Luck]) LCK'
                            }
                        }
                        If($Row.Accuracy -GT 0) {
                            If($Row.Length -GT 0) {
                                $Data += '  +$($this.TargetStats[[StatId]::Accuracy]) ACC'
                            } Else {
                                $Data += '+$($this.TargetStats[[StatId]::Accuracy]) ACC'
                            }
                        }

                        Break
                    }
                }

                $Data
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
        $ClassStringData | Out-File -FilePath $OutputFile -Append
        # Add-Content -Path $OutputFile -Value $ClassStringData
        # Start-Sleep -Seconds 0.75 # Stops a race condition for file access that can prevent some entries from being written; makes this GAWD AWFUL SLOW!
        $Itr++
    }
}


