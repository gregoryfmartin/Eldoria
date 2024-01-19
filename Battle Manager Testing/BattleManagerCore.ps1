Class BattleManager {
    [BattleManagerState]$State            = [BattleManagerState]::TurnIncrement
    [Int]$TurnCounter                     = 0
    [Int]$TurnLimit                       = 0
    [Boolean]$CanPhaseOneAct              = $true
    [Boolean]$CanPhaseTwoAct              = $true
    [BattleEntity]$PhaseOneEntity         = $null
    [BattleEntity]$PhaseTwoEntity         = $null
    [ScriptBlock]$SpoilsAction            = $null
    [BattlePhaseIndicator]$PhaseIndicator = $null

    BattleManager() {
        If($Script:BattleCursorVisible -EQ $false) {
            Write-Host "$([ATControlSequences]::CursorHide)"
            $Script:BattleCursorVisible = $true
        }
        If($null -EQ $Script:ThePlayerBattleStatWindow) {
            $Script:ThePlayerBattleStatWindow = [BattleEntityStatusWindow]::new(1, 1, 17, 19, $Script:ThePlayer)
        }
        If($null -EQ $Script:TheEnemyBattleStatWindow) {
            $Script:TheEnemyBattleStatWindow = [BattleEntityStatusWindow]::new(1, 22, 17, 40, $Script:TheCurrentEnemy)
        }
        If($null -EQ $Script:ThePlayerBattleActionWindow) {
            $Script:ThePlayerBattleActionWindow = [BattlePlayerActionWindow]::new()
        }
        If($null -EQ $Script:TheBattleStatusMessageWindow) {
            $Script:TheBattleStatusMessageWindow = [BattleStatusMessageWindow]::new()
        }
        If($null -EQ $Script:TheBattleEnemyImageWindow) {
            $Script:TheBattleEnemyImageWindow = [BattleEnemyImageWindow]::new()
        }
        If($null -EQ $this.PhaseIndicator) {
            $this.PhaseIndicator = [BattlePhaseIndicator]::new()
        }
    }

    [Void]Update() {
        $Script:ThePlayer.Update()
        $Script:TheCurrentEnemy.Update()
        $Script:ThePlayerBattleStatWindow.Draw()
        $Script:TheEnemyBattleStatWindow.Draw()
        $Script:TheBattleEnemyImageWindow.Draw()
        $Script:ThePlayerBattleActionWindow.Draw()
        $Script:TheBattleStatusMessageWindow.Draw()
        $Script:Rui.CursorPosition = $([ATCoordinates]::new(0, 0)).ToAutomationCoordinates()
        Switch($this.State) {
            TurnIncrement {
                If($this.TurnLimit -GT 0) {
                    If(($this.TurnCounter + 1) -GT $this.TurnLimit) {
                        $this.State = [BattleManagerState]::BattleLost

                        Return
                    }
                    $this.TurnCounter++
                    $this.State = [BattleManagerState]::PhaseOrdering

                    Return
                }
                $this.TurnCounter++
                $this.State = [BattleManagerState]::PhaseOrdering

                Return
            }

            PhaseOrdering {
                [Single]$PlayerEffectiveSpeed = 0.0
                [Single]$EnemyEffectiveSpeed  = 0.0

                $PlayerEffectiveSpeed = $Script:ThePlayer.Stats[[StatId]::Speed].Base + ($(Get-Random -Minimum 0.0 -Maximum 1.0) * $Script:ThePlayer.Stats[[StatId]::Luck].Base)
                $EnemyEffectiveSpeed  = $Script:TheCurrentEnemy.Stats[[StatId]::Speed].Base + ($(Get-Random -Minimum 0.0 -Maximum 1.0) * $Script:TheCurrentEnemy.Stats[[StatId]::Luck].Base)
                [Single]$EsWinner     = [Math]::Max($PlayerEffectiveSpeed, $EnemyEffectiveSpeed)
                If($EsWinner -EQ $PlayerEffectiveSpeed) {
                    $this.PhaseOneEntity = $Script:ThePlayer
                    $this.PhaseTwoEntity = $Script:TheCurrentEnemy
                } Elseif($EsWinner -EQ $EnemyEffectiveSpeed) {
                    $this.PhaseOneEntity = $Script:TheCurrentEnemy
                    $this.PhaseTwoEntity = $Script:ThePlayer
                }
                $this.State = [BattleManagerState]::PhaseAExecution

                Return
            }

            PhaseAExecution {
                If(($this.PhaseOneEntity.Stats[[StatId]::HitPoints].Base -LE 0) -OR ($this.PhaseTwoEntity.Stats[[StatId]::HitPoints].Base -LE 0)) {
                    $this.State = [BattleManagerState]::Calculation

                    Break
                }
                $this.PhaseIndicator.IndicatorDrawDirty = $true
                $this.PhaseIndicator.Draw($this.PhaseOneEntity)
                If($this.PhaseOneEntity -IS [Player]) {
                    $Script:ThePlayerBattleStatWindow.EntityBattlePhaseActive = $true
                    $Script:TheEnemyBattleStatWindow.EntityBattlePhaseActive  = $false
                } Else {
                    $Script:ThePlayerBattleStatWindow.EntityBattlePhaseActive = $false
                    $Script:TheEnemyBattleStatWindow.EntityBattlePhaseActive  = $true
                }
                $Script:ThePlayerBattleStatWindow.Draw()
                $Script:TheEnemyBattleStatWindow.Draw()
                If($this.CanPhaseOneAct -EQ $true) {
                    [BattleAction]$ToExecute          = $null
                    [BattleActionResult]$ActionResult = $null

                    If($this.PhaseOneEntity -IS [Player]) {
                        $Script:ThePlayerBattleActionWindow.SetAllActionDrawDirty()
                        While($null -EQ $ToExecute) {
                            $Script:ThePlayerBattleActionWindow.Draw()
                            $ToExecute = $Script:ThePlayerBattleActionWindow.HandleInput()
                        }
                        $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                            @(
                                [ATStringCompositeSc]::new(
                                    $this.PhaseOneEntity.NameDrawColor,
                                    [ATDecorationNone]::new(),
                                    $this.PhaseOneEntity.Name
                                ),
                                [ATStringCompositeSc]::new(
                                    [CCTextDefault24]::new(),
                                    [ATDecorationNone]::new(),
                                    ' uses '
                                ),
                                [ATStringCompositeSc]::new(
                                    $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                    [ATDecorationNone]::new(),
                                    $ToExecute.Name
                                )
                            )
                        )
                        $ActionResult = $(Invoke-Command $ToExecute.Effect -ArgumentList $this.PhaseOneEntity, $this.PhaseTwoEntity, $ToExecute)
                        $Script:ThePlayerBattleStatWindow.Draw()
                    } Else  {
                        [ActionSlot]$SelectedSlot = $($this.PhaseOneEntity.ActionMarbleBag | Get-Random)
                        $ToExecute                = $this.PhaseOneEntity.ActionListing[$SelectedSlot]
                        
                        $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                            @(
                                [ATStringCompositeSc]::new(
                                    $this.PhaseOneEntity.NameDrawColor,
                                    [ATDecorationNone]::new(),
                                    $this.PhaseOneEntity.Name
                                ),
                                [ATStringCompositeSc]::new(
                                    [CCTextDefault24]::new(),
                                    [ATDecorationNone]::new(),
                                    ' uses '
                                ),
                                [ATStringCompositeSc]::new(
                                    $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                    [ATDecorationNone]::new(),
                                    $ToExecute.Name
                                )
                            )
                        )
                        $ActionResult = $(Invoke-Command $ToExecute.Effect -ArgumentList $this.PhaseOneEntity, $this.PhaseTwoEntity, $ToExecute)
                        $Script:TheEnemyBattleStatWindow.Draw()
                    }
                    Switch($ActionResult.Type) {
                        ([BattleActionResultType]::SuccessWithCritical) {
                            $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                @(
                                    [ATStringCompositeSc]::new(
                                        $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                        [ATDecorationNone]::new(),
                                        $ToExecute.Name
                                    ),
                                    [ATStringCompositeSc]::new(
                                        [CCTextDefault24]::new(),
                                        [ATDecorationNone]::new(),
                                        ' was successful, and scored a '
                                    ),
                                    [ATStringCompositeSc]::new(
                                        [CCAppleYellowLight24]::new(),
                                        [ATDecoration]::new($true),
                                        'CRITICAL!'
                                    )
                                )
                            )
                            Switch($ToExecute.Type) {
                                ([BattleActionType]::Physical) {
                                    Try {
                                        $Script:TheSfxMPlayer.Open($Script:SfxBaPhysicalStrikeA)
                                        $Script:TheSfxMPlayer.Play()
                                    } Catch {}
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' hit '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }

                                ([BattleActionType]::ElementalFire) {
                                    Try {
                                        $Script:TheSfxMPlayer.Open($Script:SfxBaFireStrikeA)
                                        $Script:TheSfxMPlayer.Play()
                                    } Catch {}
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' burned '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }

                                ([BattleActionType]::ElementalWater) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' soaked '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }

                                ([BattleActionType]::ElementalEarth) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' stoned '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }

                                ([BattleActionType]::ElementalWind) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' sheared '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }

                                ([BattleActionType]::ElementalLight) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' cast holy power on '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }

                                ([BattleActionType]::ElementalDark) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' cast unholy power on  '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }

                                ([BattleActionType]::ElementalIce) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' cast ice powers on '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }

                                ([BattleActionType]::MagicPoison) {
                                    Break
                                }

                                ([BattleActionType]::MagicConfuse) {
                                    Break
                                }

                                ([BattleActionType]::MagicSleep) {
                                    Break
                                }

                                ([BattleActionType]::MagicAging) {
                                    Break
                                }

                                ([BattleActionType]::MagicHealing) {
                                    Break
                                }

                                ([BattleActionType]::MagicStatAugment) {
                                    Break
                                }
                            }

                            Break
                        }

                        ([BattleActionResultType]::SuccessWithAffinityBonus) {
                            $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                @(
                                    [ATStringCompositeSc]::new(
                                        $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                        [ATDecorationNone]::new(),
                                        $ToExecute.Name
                                    ),
                                    [ATStringCompositeSc]::new(
                                        [CCTextDefault24]::new(),
                                        [ATDecorationNone]::new(),
                                        ' was successful, and scored an '
                                    ),
                                    [ATStringCompositeSc]::new(
                                        [CCAppleYellowLight24]::new(),
                                        [ATDecoration]::new($true),
                                        'AFFINITY BONUS!'
                                    )
                                )
                            )
                            Switch($ToExecute.Type) {
                                ([BattleActionType]::ElementalFire) {
                                    Try {
                                        $Script:TheSfxMPlayer.Open($Script:SfxBaFireStrikeA)
                                        $Script:TheSfxMPlayer.Play()
                                    } Catch {}
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' burned '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }

                                ([BattleActionType]::ElementalWater) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' soaked '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }

                                ([BattleActionType]::ElementalEarth) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' stoned '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }

                                ([BattleActionType]::ElementalWind) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' sheared '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }

                                ([BattleActionType]::ElementalLight) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' cast holy power on '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }

                                ([BattleActionType]::ElementalDark) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' cast unholy power on  '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }

                                ([BattleActionType]::ElementalIce) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' cast ice powers on '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }

                                ([BattleActionType]::MagicPoison) {
                                    Break
                                }

                                ([BattleActionType]::MagicConfuse) {
                                    Break
                                }

                                ([BattleActionType]::MagicSleep) {
                                    Break
                                }

                                ([BattleActionType]::MagicAging) {
                                    Break
                                }

                                ([BattleActionType]::MagicHealing) {
                                    Break
                                }

                                ([BattleActionType]::MagicStatAugment) {
                                    Break
                                }
                            }

                            Break
                        }

                        ([BattleActionResultType]::SuccessWithCritAndAffinityBonus) {
                            $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                @(
                                    [ATStringCompositeSc]::new(
                                        $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                        [ATDecorationNone]::new(),
                                        $ToExecute.Name
                                    ),
                                    [ATStringCompositeSc]::new(
                                        [CCTextDefault24]::new(),
                                        [ATDecorationNone]::new(),
                                        ' was successful, and scored a '
                                    ),
                                    [ATStringCompositeSc]::new(
                                        [CCAppleYellowLight24]::new(),
                                        [ATDecoration]::new($true),
                                        'CRITICAL '
                                    ),
                                    [ATStringCompositeSc]::new(
                                        [CCTextDefault24]::new(),
                                        [ATDecorationNone]::new(),
                                        'and '
                                    ),
                                    [ATStringCompositeSc]::new(
                                        [CCAppleYellowLight24]::new(),
                                        [ATDecoration]::new($true),
                                        'AFFINITY BONUS!'
                                    )
                                )
                            )
                            Switch($ToExecute.Type) {
                                ([BattleActionType]::ElementalFire) {
                                    Try {
                                        $Script:TheSfxMPlayer.Open($Script:SfxBaFireStrikeA)
                                        $Script:TheSfxMPlayer.Play()
                                    } Catch {}
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' burned '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }

                                ([BattleActionType]::ElementalWater) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' soaked '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }

                                ([BattleActionType]::ElementalEarth) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' stoned '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }

                                ([BattleActionType]::ElementalWind) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' sheared '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }

                                ([BattleActionType]::ElementalLight) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' cast holy power on '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }

                                ([BattleActionType]::ElementalDark) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' cast unholy power on  '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }

                                ([BattleActionType]::ElementalIce) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' cast ice powers on '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }

                                ([BattleActionType]::MagicPoison) {
                                    Break
                                }

                                ([BattleActionType]::MagicConfuse) {
                                    Break
                                }

                                ([BattleActionType]::MagicSleep) {
                                    Break
                                }

                                ([BattleActionType]::MagicAging) {
                                    Break
                                }

                                ([BattleActionType]::MagicHealing) {
                                    Break
                                }

                                ([BattleActionType]::MagicStatAugment) {
                                    Break
                                }
                            }

                            Break
                        }

                        ([BattleActionResultType]::Success) {
                            $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                @(
                                    [ATStringCompositeSc]::new(
                                        $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                        [ATDecorationNone]::new(),
                                        $ToExecute.Name
                                    ),
                                    [ATStringCompositeSc]::new(
                                        [CCTextDefault24]::new(),
                                        [ATDecorationNone]::new(),
                                        ' was successful!'
                                    )
                                )
                            )
                            Switch($ToExecute.Type) {
                                ([BattleActionType]::Physical) {
                                    Try {
                                        $Script:TheSfxMPlayer.Open($Script:SfxBaPhysicalStrikeA)
                                        $Script:TheSfxMPlayer.Play()
                                    } Catch {}
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' hit '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }

                                ([BattleActionType]::ElementalFire) {
                                    Try {
                                        $Script:TheSfxMPlayer.Open($Script:SfxBaFireStrikeA)
                                        $Script:TheSfxMPlayer.Play()
                                    } Catch {}
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' burned '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }

                                ([BattleActionType]::ElementalWater) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' soaked '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }

                                ([BattleActionType]::ElementalEarth) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' stoned '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }

                                ([BattleActionType]::ElementalWind) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' sheared '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }

                                ([BattleActionType]::ElementalLight) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' cast holy power on '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }

                                ([BattleActionType]::ElementalDark) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' cast unholy power on  '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }

                                ([BattleActionType]::ElementalIce) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' cast ice powers on '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }

                                ([BattleActionType]::MagicPoison) {
                                    Break
                                }

                                ([BattleActionType]::MagicConfuse) {
                                    Break
                                }

                                ([BattleActionType]::MagicSleep) {
                                    Break
                                }

                                ([BattleActionType]::MagicAging) {
                                    Break
                                }

                                ([BattleActionType]::MagicHealing) {
                                    Break
                                }

                                ([BattleActionType]::MagicStatAugment) {
                                    Break
                                }
                            }

                            Break
                        }

                        ([BattleActionResultType]::FailedAttackMissed) {
                            Try {
                                $Script:TheSfxMPlayer.Open($Script:SfxBaMissFail)
                                $Script:TheSfxMPlayer.Play()
                            } Catch {}
                            $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                @(
                                    [ATStringCompositeSc]::new(
                                        $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                        [ATDecorationNone]::new(),
                                        $ToExecute.Name
                                    ),
                                    [ATStringCompositeSc]::new(
                                        [CCTextDefault24]::new(),
                                        [ATDecorationNone]::new(),
                                        ' missed!'
                                    )
                                )
                            )

                            Break
                        }

                        ([BattleActionResultType]::FailedAttackFailed) {
                            Try {
                                $Script:TheSfxMPlayer.Open($Script:SfxBaMissFail)
                                $Script:TheSfxMPlayer.Play()
                            } Catch {}
                            $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                @(
                                    [ATStringCompositeSc]::new(
                                        $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                        [ATDecorationNone]::new(),
                                        $ToExecute.Name
                                    ),
                                    [ATStringCompositeSc]::new(
                                        [CCTextDefault24]::new(),
                                        [ATDecorationNone]::new(),
                                        ' failed!'
                                    )
                                )
                            )

                            Break
                        }

                        ([BattleActionResultType]::FailedElementalMatch) {
                            Break
                        }
                    }
                } Else {
                    Try {
                        $Script:TheSfxMPlayer.Open($Script:SfxBaActionDisabled)
                        $Script:TheSfxMPlayer.Play()
                    } Catch {}
                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                        @(
                            [ATStringCompositeSc]::new(
                                $this.PhaseOneEntity.NameDrawColor,
                                [ATDecorationNone]::new(),
                                $this.PhaseOneEntity.Name
                            ),
                            [ATStringCompositeSc]::new(
                                [CCTextDefault24]::new(),
                                [ATDecorationNone]::new(),
                                ' is unable to act at this time!'
                            )
                        )
                    )
                }
                Foreach($Stat in $this.PhaseOneEntity.Stats.Values) {
                    If($Stat.AugmentTurnDuration -GT 0) {
                        $Stat.AugmentTurnDuration--
                        If($Stat.AugmentTurnDuration -EQ 0) {
                            If($this.PhaseOneEntity -IS [Player]) {
                                $Stat.Update()
                                $Script:ThePlayerBattleStatWindow.SetAllFlagsDirty()
                                $Script:ThePlayerBattleStatWindow.Draw()
                            } Else {
                                $Stat.Update()
                                $Script:TheEnemyBattleStatWindow.SetAllFlagsDirty()
                                $Script:TheEnemyBattleStatWindow.Draw()
                            }
                        }
                    }
                }
                $this.State = [BattleManagerState]::PhaseBExecution

                Break
            }

            PhaseBExecution {
                If(($this.PhaseTwoEntity.Stats[[StatId]::HitPoints].Base -LE 0) -OR ($this.PhaseOneEntity.Stats[[StatId]::HitPoints].Base -LE 0)) {
                    $this.State = [BattleManagerState]::Calculation

                    Break
                }
                $this.PhaseIndicator.IndicatorDrawDirty = $true
                $this.PhaseIndicator.Draw($this.PhaseTwoEntity)
                If($this.PhaseTwoEntity -IS [Player]) {
                    $Script:ThePlayerBattleStatWindow.EntityBattlePhaseActive = $true
                    $Script:TheEnemyBattleStatWindow.EntityBattlePhaseActive  = $false
                } Else {
                    $Script:ThePlayerBattleStatWindow.EntityBattlePhaseActive = $false
                    $Script:TheEnemyBattleStatWindow.EntityBattlePhaseActive  = $true
                }
                $Script:ThePlayerBattleStatWindow.Draw()
                $Script:TheEnemyBattleStatWindow.Draw()
                If($this.CanPhaseTwoAct -EQ $true) {
                    [BattleAction]$ToExecute          = $null
                    [BattleActionResult]$ActionResult = $null

                    If($this.PhaseTwoEntity -IS [Player]) {
                        $Script:ThePlayerBattleActionWindow.SetAllActionDrawDirty()
                        While($null -EQ $ToExecute) {
                            $Script:ThePlayerBattleActionWindow.Draw()
                            $ToExecute = $Script:ThePlayerBattleActionWindow.HandleInput()
                        }
                        $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                            @(
                                [ATStringCompositeSc]::new(
                                    $this.PhaseTwoEntity.NameDrawColor,
                                    [ATDecorationNone]::new(),
                                    $this.PhaseTwoEntity.Name
                                ),
                                [ATStringCompositeSc]::new(
                                    [CCTextDefault24]::new(),
                                    [ATDecorationNone]::new(),
                                    ' uses '
                                ),
                                [ATStringCompositeSc]::new(
                                    $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                    [ATDecorationNone]::new(),
                                    $ToExecute.Name
                                )
                            )
                        )
                        $ActionResult = $(Invoke-Command $ToExecute.Effect -ArgumentList $this.PhaseTwoEntity, $this.PhaseOneEntity, $ToExecute)
                        $Script:ThePlayerBattleStatWindow.Draw()
                    } Else {
                        [ActionSlot]$SelectedSlot = $($this.PhaseTwoEntity.ActionMarbleBag | Get-Random)
                        $ToExecute                = $this.PhaseTwoEntity.ActionListing[$SelectedSlot]
                        
                        $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                            @(
                                [ATStringCompositeSc]::new(
                                    $this.PhaseTwoEntity.NameDrawColor,
                                    [ATDecorationNone]::new(),
                                    $this.PhaseTwoEntity.Name
                                ),
                                [ATStringCompositeSc]::new(
                                    [CCTextDefault24]::new(),
                                    [ATDecorationNone]::new(),
                                    ' uses '
                                ),
                                [ATStringCompositeSc]::new(
                                    $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                    [ATDecorationNone]::new(),
                                    $ToExecute.Name
                                )
                            )
                        )
                        $ActionResult = $(Invoke-Command $ToExecute.Effect -ArgumentList $this.PhaseTwoEntity, $this.PhaseOneEntity, $ToExecute)
                        $Script:TheEnemyBattleStatWindow.Draw()
                    }
                    Switch($ActionResult.Type) {
                        ([BattleActionResultType]::SuccessWithCritical) {
                            $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                @(
                                    [ATStringCompositeSc]::new(
                                        $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                        [ATDecorationNone]::new(),
                                        $ToExecute.Name
                                    ),
                                    [ATStringCompositeSc]::new(
                                        [CCTextDefault24]::new(),
                                        [ATDecorationNone]::new(),
                                        ' was successful, and scored a '
                                    ),
                                    [ATStringCompositeSc]::new(
                                        [CCAppleYellowLight24]::new(),
                                        [ATDecoration]::new($true),
                                        'CRITICAL!'
                                    )
                                )
                            )
                            Switch($ToExecute.Type) {
                                ([BattleActionType]::Physical) {
                                    Try {
                                        $Script:TheSfxMPlayer.Open($Script:SfxBaPhysicalStrikeA)
                                        $Script:TheSfxMPlayer.Play()
                                    } Catch {}
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' hit '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }
    
                                ([BattleActionType]::ElementalFire) {
                                    Try {
                                        $Script:TheSfxMPlayer.Open($Script:SfxBaFireStrikeA)
                                        $Script:TheSfxMPlayer.Play()
                                    } Catch {}
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' burned '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }
    
                                ([BattleActionType]::ElementalWater) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' soaked '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }
    
                                ([BattleActionType]::ElementalEarth) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' stoned '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }
    
                                ([BattleActionType]::ElementalWind) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' sheared '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }
    
                                ([BattleActionType]::ElementalLight) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' cast holy power on '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }
    
                                ([BattleActionType]::ElementalDark) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' cast unholy power on  '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }
    
                                ([BattleActionType]::ElementalIce) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' cast ice powers on '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }
    
                                ([BattleActionType]::MagicPoison) {
                                    Break
                                }
    
                                ([BattleActionType]::MagicConfuse) {
                                    Break
                                }
    
                                ([BattleActionType]::MagicSleep) {
                                    Break
                                }
    
                                ([BattleActionType]::MagicAging) {
                                    Break
                                }
    
                                ([BattleActionType]::MagicHealing) {
                                    Break
                                }
    
                                ([BattleActionType]::MagicStatAugment) {
                                    Break
                                }
                            }

                            Break
                        }

                        ([BattleActionResultType]::SuccessWithAffinityBonus) {
                            $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                @(
                                    [ATStringCompositeSc]::new(
                                        $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                        [ATDecorationNone]::new(),
                                        $ToExecute.Name
                                    ),
                                    [ATStringCompositeSc]::new(
                                        [CCTextDefault24]::new(),
                                        [ATDecorationNone]::new(),
                                        ' was successful, and scored an '
                                    ),
                                    [ATStringCompositeSc]::new(
                                        [CCAppleYellowLight24]::new(),
                                        [ATDecoration]::new($true),
                                        'AFFINITY BONUS!'
                                    )
                                )
                            )
                            Switch($ToExecute.Type) {    
                                ([BattleActionType]::ElementalFire) {
                                    Try {
                                        $Script:TheSfxMPlayer.Open($Script:SfxBaFireStrikeA)
                                        $Script:TheSfxMPlayer.Play()
                                    } Catch {}
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' burned '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }
    
                                ([BattleActionType]::ElementalWater) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' soaked '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }
    
                                ([BattleActionType]::ElementalEarth) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' stoned '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }
    
                                ([BattleActionType]::ElementalWind) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' sheared '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }
    
                                ([BattleActionType]::ElementalLight) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' cast holy power on '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }
    
                                ([BattleActionType]::ElementalDark) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' cast unholy power on  '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }
    
                                ([BattleActionType]::ElementalIce) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' cast ice powers on '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }
    
                                ([BattleActionType]::MagicPoison) {
                                    Break
                                }
    
                                ([BattleActionType]::MagicConfuse) {
                                    Break
                                }
    
                                ([BattleActionType]::MagicSleep) {
                                    Break
                                }
    
                                ([BattleActionType]::MagicAging) {
                                    Break
                                }
    
                                ([BattleActionType]::MagicHealing) {
                                    Break
                                }
    
                                ([BattleActionType]::MagicStatAugment) {
                                    Break
                                }
                            }

                            Break
                        }

                        ([BattleActionResultType]::SuccessWithCritAndAffinityBonus) {
                            $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                @(
                                    [ATStringCompositeSc]::new(
                                        $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                        [ATDecorationNone]::new(),
                                        $ToExecute.Name
                                    ),
                                    [ATStringCompositeSc]::new(
                                        [CCTextDefault24]::new(),
                                        [ATDecorationNone]::new(),
                                        ' was successful, and scored a '
                                    ),
                                    [ATStringCompositeSc]::new(
                                        [CCAppleYellowLight24]::new(),
                                        [ATDecoration]::new($true),
                                        'CRITICAL '
                                    ),
                                    [ATStringCompositeSc]::new(
                                        [CCTextDefault24]::new(),
                                        [ATDecorationNone]::new(),
                                        'and '
                                    ),
                                    [ATStringCompositeSc]::new(
                                        [CCAppleYellowLight24]::new(),
                                        [ATDecoration]::new($true),
                                        'AFFINITY BONUS!'
                                    )
                                )
                            )
                            Switch($ToExecute.Type) {    
                                ([BattleActionType]::ElementalFire) {
                                    Try {
                                        $Script:TheSfxMPlayer.Open($Script:SfxBaFireStrikeA)
                                        $Script:TheSfxMPlayer.Play()
                                    } Catch {}
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' burned '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }
    
                                ([BattleActionType]::ElementalWater) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' soaked '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }
    
                                ([BattleActionType]::ElementalEarth) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' stoned '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }
    
                                ([BattleActionType]::ElementalWind) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' sheared '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }
    
                                ([BattleActionType]::ElementalLight) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' cast holy power on '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }
    
                                ([BattleActionType]::ElementalDark) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' cast unholy power on  '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }
    
                                ([BattleActionType]::ElementalIce) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' cast ice powers on '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }
    
                                ([BattleActionType]::MagicPoison) {
                                    Break
                                }
    
                                ([BattleActionType]::MagicConfuse) {
                                    Break
                                }
    
                                ([BattleActionType]::MagicSleep) {
                                    Break
                                }
    
                                ([BattleActionType]::MagicAging) {
                                    Break
                                }
    
                                ([BattleActionType]::MagicHealing) {
                                    Break
                                }
    
                                ([BattleActionType]::MagicStatAugment) {
                                    Break
                                }
                            }

                            Break
                        }

                        ([BattleActionResultType]::Success) {
                            $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                @(
                                    [ATStringCompositeSc]::new(
                                        $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                        [ATDecorationNone]::new(),
                                        $ToExecute.Name
                                    ),
                                    [ATStringCompositeSc]::new(
                                        [CCTextDefault24]::new(),
                                        [ATDecorationNone]::new(),
                                        ' was successful!'
                                    )
                                )
                            )
                            Switch($ToExecute.Type) {
                                ([BattleActionType]::Physical) {
                                    Try {
                                        $Script:TheSfxMPlayer.Open($Script:SfxBaPhysicalStrikeA)
                                        $Script:TheSfxMPlayer.Play()
                                    } Catch {}
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' hit '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }
    
                                ([BattleActionType]::ElementalFire) {
                                    Try {
                                        $Script:TheSfxMPlayer.Open($Script:SfxBaFireStrikeA)
                                        $Script:TheSfxMPlayer.Play()
                                    } Catch {}
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' burned '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }
    
                                ([BattleActionType]::ElementalWater) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' soaked '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }
    
                                ([BattleActionType]::ElementalEarth) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' stoned '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }
    
                                ([BattleActionType]::ElementalWind) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' sheared '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }
    
                                ([BattleActionType]::ElementalLight) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' cast holy power on '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }
    
                                ([BattleActionType]::ElementalDark) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' cast unholy power on  '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }
    
                                ([BattleActionType]::ElementalIce) {
                                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                        @(
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseTwoEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseTwoEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' cast ice powers on '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $this.PhaseOneEntity.NameDrawColor,
                                                [ATDecorationNone]::new(),
                                                $this.PhaseOneEntity.Name
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' for '
                                            ),
                                            [ATStringCompositeSc]::new(
                                                $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                                [ATDecorationNone]::new(),
                                                $ActionResult.ActionEffectSum
                                            ),
                                            [ATStringCompositeSc]::new(
                                                [CCTextDefault24]::new(),
                                                [ATDecorationNone]::new(),
                                                ' damage.'
                                            )
                                        )
                                    )

                                    Break
                                }
    
                                ([BattleActionType]::MagicPoison) {
                                    Break
                                }
    
                                ([BattleActionType]::MagicConfuse) {
                                    Break
                                }
    
                                ([BattleActionType]::MagicSleep) {
                                    Break
                                }
    
                                ([BattleActionType]::MagicAging) {
                                    Break
                                }
    
                                ([BattleActionType]::MagicHealing) {
                                    Break
                                }
    
                                ([BattleActionType]::MagicStatAugment) {
                                    Break
                                }
                            }
                            Break
                        }
    
                        ([BattleActionResultType]::FailedAttackMissed) {
                            Try {
                                $Script:TheSfxMPlayer.Open($Script:SfxBaMissFail)
                                $Script:TheSfxMPlayer.Play()
                            } Catch {}
                            $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                @(
                                    [ATStringCompositeSc]::new(
                                        $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                        [ATDecorationNone]::new(),
                                        $ToExecute.Name
                                    ),
                                    [ATStringCompositeSc]::new(
                                        [CCTextDefault24]::new(),
                                        [ATDecorationNone]::new(),
                                        ' missed!'
                                    )
                                )
                            )

                            Break
                        }
    
                        ([BattleActionResultType]::FailedAttackFailed) {
                            Try {
                                $Script:TheSfxMPlayer.Open($Script:SfxBaMissFail)
                                $Script:TheSfxMPlayer.Play()
                            } Catch {}
                            $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                                @(
                                    [ATStringCompositeSc]::new(
                                        $Script:BATAdornmentCharTable[$ToExecute.Type].Item2,
                                        [ATDecorationNone]::new(),
                                        $ToExecute.Name
                                    ),
                                    [ATStringCompositeSc]::new(
                                        [CCTextDefault24]::new(),
                                        [ATDecorationNone]::new(),
                                        ' failed!'
                                    )
                                )
                            )

                            Break
                        }
    
                        ([BattleActionResultType]::FailedElementalMatch) {
                            Break
                        }
                    }
                } Else {
                    Try {
                        $Script:TheSfxMPlayer.Open($Script:SfxBaActionDisabled)
                        $Script:TheSfxMPlayer.Play()
                    } Catch {}
                    $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                        @(
                            [ATStringCompositeSc]::new(
                                $this.PhaseTwoEntity.NameDrawColor,
                                [ATDecorationNone]::new(),
                                $this.PhaseTwoEntity.Name
                            ),
                            [ATStringCompositeSc]::new(
                                [CCTextDefault24]::new(),
                                [ATDecorationNone]::new(),
                                ' is unable to act at this time!'
                            )
                        )
                    )
                }
                Foreach($Stat in $this.PhaseTwoEntity.Stats.Values) {
                    If($Stat.AugmentTurnDuration -GT 0) {
                        $Stat.AugmentTurnDuration--
                        If($Stat.AugmentTurnDuration -EQ 0) {
                            If($this.PhaseTwoEntity -IS [Player]) {
                                $Stat.Update()
                                $Script:ThePlayerBattleStatWindow.SetAllFlagsDirty()
                                $Script:ThePlayerBattleStatWindow.Draw()
                            } Else {
                                $Stat.Update()
                                $Script:TheEnemyBattleStatWindow.SetAllFlagsDirty()
                                $Script:TheEnemyBattleStatWindow.Draw()
                            }
                        }
                    }
                }
                $this.State = [BattleManagerState]::TurnIncrement
                
                Break
            }

            Calculation {
                If($this.PhaseOneEntity.Stats[[StatId]::HitPoints].Base -LE 0) {
                    If($this.PhaseOneEntity -IS [Player]) {
                        $this.State = [BattleManagerState]::BattleLost

                        Break
                    } Else {
                        $this.SpoilsAction = $this.PhaseTwoEntity.SpoilsEffect
                        $this.State        = [BattleManagerState]::BattleWon

                        Break
                    }
                } Elseif($this.PhaseTwoEntity.Stats[[StatId]::HitPoints].Base -LE 0) {
                    If($this.PhaseTwoEntity -IS [Player]) {
                        $this.State = [BattleManagerState]::BattleLost

                        Break
                    } Else {
                        $this.SpoilsAction = $this.PhaseOneEntity.SpoilsEffect
                        $this.State        = [BattleManagerState]::BattleWon

                        Break
                    }
                }
                $this.State = [BattleManagerState]::TurnIncrement

                Break
            }

            BattleWon {
                $Script:TheBgmMPlayer.Stop()
                If($Script:HasBattleWonChimePlayed -EQ $false) {
                    Try {
                        $Script:TheSfxMPlayer.Open($Script:SfxBattlePlayerWin)
                        $Script:TheSfxMPlayer.Play()
                    } Catch {}
                    $Script:HasBattleWonChimePlayed = $true
                }
                $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                    @(
                        [ATStringCompositeSc]::new(
                            [CCTextDefault24]::new(),
                            [ATDecorationNone]::new(),
                            'You''ve won the battle!'
                        )
                    )
                )
                $Script:TheBattleStatusMessageWindow.Draw()
                If($this.PhaseOneEntity -IS [Player]) {
                    $this.SpoilsAction = $this.PhaseTwoEntity.SpoilsEffect
                    Invoke-Command $this.SpoilsAction -ArgumentList ([Player]$this.PhaseOneEntity), ([EnemyBattleEntity]$this.PhaseTwoEntity)
                } Elseif($this.PhaseTwoEntity -IS [Player]) {
                    $this.SpoilsAction = $this.PhaseOneEntity.SpoilsEffect
                    Invoke-Command $this.SpoilsAction -ArgumentList ([Player]$this.PhaseTwoEntity), ([EnemyBattleEntity]$this.PhaseOneEntity)
                }
                $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                    @(
                        [ATStringCompositeSc]::new(
                            [CCTextDefault24]::new(),
                            [ATDecorationNone]::new(),
                            'Press ''Enter'' to exit.'
                        )
                    )
                )
                $Script:TheBattleStatusMessageWindow.Draw()
                $a = $Script:Rui.ReadKey('IncludeKeyDown, NoEcho')
                While($a.VirtualKeyCode -NE 13) {
                    $a = $Script:Rui.ReadKey('IncludeKeyDown, NoEcho')
                }
                $Script:ThePreviousGlobalGameState = $Script:TheGlobalGameState
                $Script:TheGlobalGameState         = [GameStatePrimary]::GamePlayScreen

                Break
            }

            BattleLost {
                $Script:TheBgmMPlayer.Stop()
                If($Script:HasBattleLostChimePlayed -EQ $false) {
                    $Script:TheSfxMachine.SoundLocation = $Script:SfxBattlePlayerLose
                    $Script:TheSfxMachine.Play()
                    $Script:HasBattleLostChimePlayed = $true
                }
                $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                    @(
                        [ATStringCompositeSc]::new(
                            [CCTextDefault24]::new(),
                            [ATDecorationNone]::new(),
                            'You''ve lost the battle.'
                        )
                    )
                )
                $Script:TheBattleStatusMessageWindow.Draw()
                $Script:TheBattleStatusMessageWindow.WriteCompositeMessage(
                    @(
                        [ATStringCompositeSc]::new(
                            [CCAppleRedDark24]::new(),
                            [ATDecoration]@{
                                Blink = $true
                            },
                            'GAME OVER'
                        )
                    )
                )
                $Script:TheBattleStatusMessageWindow.Draw()
                Start-Sleep -Seconds 5
                Clear-Host
                
                Exit
            }

            Default {}
        }
    }

    [Void]Cleanup() {
        $Script:BattleCursorVisible          = $false
        $Script:ThePlayerBattleStatWindow    = $null
        $Script:TheEnemyBattleStatWindow     = $null
        $Script:ThePlayerBattleActionWindow  = $null
        $Script:TheBattleStatusMessageWindow = $null
        $Script:TheBattleEnemyImageWindow    = $null
        $Script:HasBattleIntroPlayed         = $false
        $Script:IsBattleBgmPlaying           = $false
        $Script:HasBattleWonChimePlayed      = $false
        $Script:HasBattleLostChimePlayed     = $false
    }
}
