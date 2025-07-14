using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BATTLE MANAGER
#
# THIS CLASS IS SUBJECT TO SERIOUS REFACTORING AT THIS POINT. MOST OF THE CODE
# HERE IS TOTAL GARBAGE.
#
###############################################################################

Class BattleManager {
    [Int]$TurnCounter
    [Int]$TurnLimit
    [BattleEntity]$PhaseOneEntity
    [BattleEntity]$PhaseTwoEntity
    [BattleManagerState]$State

    # AT THIS POINT, I'VE OMITTED THE TWO ACTION FLAGS (THESE SHOULD COME FROM THE ENTITIES THEMSELVES)
    # AND THE SPOILS ACTION MEMBER; NOT SURE WHAT THE FUCK I NEEDED THAT THING FOR. I PROBABLY STILL
    # NEED IT, BUT I'LL WORK AROUND IT.

    BattleManager() {
        # THIS CTOR DID A WHOLE BUNCH OF CRAP THAT REALLY SHOULD BE IN THE STATE TABLE. I'M NOT DOING
        # THAT STUFF HERE.
    }

    [Void]Update() {
        # MAKE PRELIMINARY OUT-OF-BAND DRAW CALLS TO ENSURE THAT THE VISUAL DISPLAY IS KOSHER
        $Script:ThePlayer.Update()
        $Script:TheCurrentEnemy.Update()
        $Script:ThePlayerBattleStatWindow.Draw()
        $Script:TheEnemyBattleStatWindow.Draw()
        $Script:TheBattleEnemyImageWindow.Draw()
        $Script:ThePlayerBattleActionWindow.Draw()
        $Script:TheBattleStatusMessageWindow.Draw()
        $Script:Rui.CursorPosition = $([ATCoordinates]::new(0, 0)).ToAutomationCoordinates()

        # HERE COMES THE HONKER BLOCK
        # THESE CASES WERE ORIGINALLY UNSCOPED, WHICH IS FUCKING LAZY ON MY PART
        Switch($this.State) {
            ([BattleManagerState]::TurnIncrement) {
                If($this.TurnLimit -GT 0) {
                    If(($this.TurnCounter + 1) -GT $this.TurnLimit) {
                        $this.State = [BattleManagerState]::BattleLost

                        Return
                    }
                }
                $this.TurnCounter++
                $this.State = [BattleManagerState]::PhaseOrdering

                Return
            }

            ([BattleManagerState]::PhaseOrdering) {
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

            ([BattleManagerState]::PhaseAExecution) {
                # THE FIRST OF THE NASTY BLOCKS
                # DESPITE THIS BEING A SECOND PASS AT THIS CODE, I'LL BE COMMENTING ALONG THE WAY

                # BEFORE DOING ANYTHING, MAKE SURE THAT WE DON'T NEED TO CHANGE OUT TO THE CALCULATION STATE
                # THIS HELPS FACILITATE, PRIMARILY, THAT AN ENTITY CAN'T ACT IF THEY'RE ACTUALLY "DEAD"
                If(($this.PhaseOneEntity.Stats[[StatId]::HitPoints].Base -LE 0) -OR ($this.PhaseTwoEntity.Stats[[StatId]::HitPoints].Base -LE 0)) {
                    $this.State = [BattleManagerState]::Calculation

                    Break
                }

                # UPDATE THE PHASE INDICATOR
                $Script:TheBattlePhaseIndicator.IndicatorDrawDirty = $true
                $Script:TheBattlePhaseIndicator.Draw($this.PhaseOneEntity)

                # ENSURE THAT THE CORRESPONDING STATUS WINDOW HAS A HIGHLIGHT AROUND THE BORDER
                If($this.PhaseOneEntity -IS [Player]) {
                    $Script:ThePlayerBattleStatWindow.EntityBattlePhaseActive = $true
                    $Script:TheEnemyBattleStatWindow.EntityBattlePhaseActive  = $false
                } Else {
                    $Script:ThePlayerBattleStatWindow.EntityBattlePhaseActive = $false
                    $Script:TheEnemyBattleStatWindow.EntityBattlePhaseActive  = $true
                }
                $Script:ThePlayerBattleStatWindow.Draw()
                $Script:TheEnemyBattleStatWindow.Draw()

                # CHECK TO SEE IF THE PHASE ONE ENTITY CAN ACTUALLY ACT
                # REASONS THEY COULDN'T INCLUDE, BUT AREN'T LIMITED TO, STATUS AILMENTS LIKE SLEEP OR PARALYSIS
                If($this.PhaseOneEntity.CanAct -EQ $true) {
                    [BattleAction]$ToExecute          = $null
                    [BattleActionResult]$ActionResult = $null

                    # DETERMINE IF THE PHASE ONE ENTITY IS THE PLAYER OR NOT
                    # DIFFERENT LOGIC NEEDS TO OCCUR DEPENDING UPON THIS DECISION
                    # IF IT'S THE PLAYER, WE NEED TO BLOCK LOOP ON THE BATTLE ACTION
                    # SELECTION WINDOW SO THE PLAYER CAN CHOOSE AN ATTACK TO EXECUTE.
                    If($this.PhaseOneEntity -IS [Player]) {
                        # REFRESH THE BATTLE ACTION SELECTION WINDOW AND BLOCK LOOP ON IT
                        # THE RESULT OF THE SELECTION IS STORED IN TOEXECUTE
                        # NOTE THAT THIS IMPLEMENTATION OF HANDLEINPUT IS AN ANTI-PATTERN
                        # BUT IS REQUIRED
                        $Script:ThePlayerBattleActionWindow.SetAllActionDrawDirty()
                        While($null -EQ $ToExecute) {
                            $Script:ThePlayerBattleActionWindow.Draw()
                            $ToExecute = $Script:ThePlayerBattleActionWindow.HandleInput()
                        }

                        # THIS IS WHERE THINGS START GETTING HAIRY
                        # A LITANY OF CALLS TO WRITECOMPOSITEMESSAGE ON THE BATTLESTATUSMESSAGEWINDOW
                        # OCCUR FOLLOWING. I'M GOING TO ATTEMPT TO CONDENSE THESE CALLS.
                        $Script:TheBattleStatusMessageWindow.WriteEntityUsesMessage(
                            $this.PhaseOneEntity,
                            $this.PhaseTwoEntity,
                            $ToExecute
                        )

                        # ACTUALLY EXECUTE THE SELECTED COMMAND
                        # PS DOES SOME GOOFY SHIT WITH DISPATCHING THESE CALLS TO ICM, BUT THIS HASN'T CAUSED ANY PROBLEMS AFTER MANY HOURS
                        # OF TESTING THUS FAR.
                        $ActionResult = $(Invoke-Command $ToExecute.Effect -ArgumentList $this.PhaseOneEntity, $this.PhaseTwoEntity, $ToExecute)

                        # REFRESH THE PLAYER BATTLE STATUS WINDOW
                        $Script:ThePlayerBattleStatWindow.Draw()
                    } Else {
                        # THE PHASE ONE ENTITY IS THE ENEMY
                        # THE ACTION THE ENEMY USES IS SELECTED FROM THE "MARBLE BAG", SO NO DELAY IS NEEDED HERE.
                        [ActionSlot]$SelectedSlot = $($this.PhaseOneEntity.ActionMarbleBag | Get-Random)
                        $ToExecute                = $this.PhaseOneEntity.ActionListing[$SelectedSlot]

                        # NOTIFY THE BATTLE STATUS MESSAGE WINDOW
                        $Script:TheBattleStatusMessageWindow.WriteEntityUsesMessage(
                            $this.PhaseOneEntity,
                            $this.PhaseTwoEntity,
                            $ToExecute
                        )

                        # EXECUTE THE ACTION AND UPDATE THE ENEMY'S BATTLE STATUS WINDOW
                        $ActionResult = $(Invoke-Command $ToExecute.Effect -ArgumentList $this.PhaseOneEntity, $this.PhaseTwoEntity, $ToExecute)
                        $Script:TheEnemyBattleStatWindow.Draw()
                    }

                    # WE NEED TO EXAMINE THE ACTION RESULT TO SEE WHAT HAPPENED AS A CONSEQUENCE OF RUNNING THE SELECTED ACTION
                    # THIS IS DONE FIRST BY LOOKING AT THE VALUE OF THE TYPE PROPERTY
                    Switch($ActionResult.Type) {
                        ([BattleActionResultType]::SuccessWithCritical) {
                            $Script:TheBattleStatusMessageWindow.WriteBarSwc($ToExecute)

                            Break
                        }

                        ([BattleActionResultType]::SuccessWithAffinityBonus) {
                            $Script:TheBattleStatusMessageWindow.WriteBarAff($ToExecute)

                            Break
                        }

                        ([BattleActionResultType]::SuccessWithCritAndAffinityBonus) {
                            $Script:TheBattleStatusMessageWindow.WriteBarCritAff($ToExecute)

                            Break
                        }

                        ([BattleActionResultType]::Success) {
                            $Script:TheBattleStatusMessageWindow.WriteBarSuccess($ToExecute)

                            Break
                        }

                        ([BattleActionResultType]::FailedAttackMissed) {
                            Try {
                                $Script:TheSfxMPlayer.Open($Script:SfxBaMissFail)
                                $Script:TheSfxMPlayer.Play()
                            } Catch {}

                            $Script:TheBattleStatusMessageWindow.WriteBarFailMissed($ToExecute)

                            Break
                        }

                        ([BattleActionResultType]::FailedAttackFailed) {
                            Try {
                                $Script:TheSfxMPlayer.Open($Script:SfxBaMissFail)
                                $Script:TheSfxMPlayer.Play()
                            } Catch {}

                            $Script:TheBattleStatusMessageWindow.WriteBarFailFailed($ToExecute)

                            Break
                        }
                    }

                    # NEXT WE NEED TO EXAMINE THE TYPE OF THE ACTION EXECUTED TO DO PROVIDE SOME
                    # ADDITIONAL FEEDBACK
                    Switch($ToExecute.Type) {
                        ([BattleActionType]::Physical) {
                            Try {
                                $Script:TheSfxMPlayer.Open($Script:SfxBaPhysicalStrikeA)
                                $Script:TheSfxMPlayer.Play()
                            } Catch {}

                            $Script:TheBattleStatusMessageWindow.WriteBatPhysical(
                                $this.PhaseOneEntity,
                                $this.PhaseTwoEntity,
                                $ToExecute,
                                $ActionResult
                            )

                            Break
                        }

                        ([BattleActionType]::ElementalFire) {
                            Try {
                                $Script:TheSfxMPlayer.Open($Script:SfxBaFireStrikeA)
                                $Script:TheSfxMPlayer.Play()
                            } Catch {}

                            $Script:TheBattleStatusMessageWindow.WriteBatElementalFire(
                                $this.PhaseOneEntity,
                                $this.PhaseTwoEntity,
                                $ToExecute,
                                $ActionResult
                            )

                            Break
                        }

                        ([BattleActionType]::ElementalWater) {
                            # TODO: ADD SOUND EFFECT FOR THIS ELEMENT

                            $Script:TheBattleStatusMessageWindow.WriteBatElementalWater(
                                $this.PhaseOneEntity,
                                $this.PhaseTwoEntity,
                                $ToExecute,
                                $ActionResult
                            )

                            Break
                        }

                        ([BattleActionType]::ElementalEarth) {
                            # TODO: ADD SOUND EFFECT FOR THIS ELEMENT

                            $Script:TheBattleStatusMessageWindow.WriteBatElementalEarth(
                                $this.PhaseOneEntity,
                                $this.PhaseTwoEntity,
                                $ToExecute,
                                $ActionResult
                            )

                            Break
                        }

                        ([BattleActionType]::ElementalWind) {
                            # TODO: ADD SOUND EFFECT FOR THIS ELEMENT

                            $Script:TheBattleStatusMessageWindow.WriteBatElementalWind(
                                $this.PhaseOneEntity,
                                $this.PhaseTwoEntity,
                                $ToExecute,
                                $ActionResult
                            )

                            Break
                        }

                        ([BattleActionType]::ElementalLight) {
                            # TODO: ADD SOUND EFFECT FOR THIS ELEMENT

                            $Script:TheBattleStatusMessageWindow.WriteBatElementalLight(
                                $this.PhaseOneEntity,
                                $this.PhaseTwoEntity,
                                $ToExecute,
                                $ActionResult
                            )

                            Break
                        }

                        ([BattleActionType]::ElementalDark) {
                            # TODO: ADD SOUND EFFECT FOR THIS ELEMENT

                            $Script:TheBattleStatusMessageWindow.WriteBatElementalDark(
                                $this.PhaseOneEntity,
                                $this.PhaseTwoEntity,
                                $ToExecute,
                                $ActionResult
                            )

                            Break
                        }

                        ([BattleActionType]::ElementalIce) {
                            # TODO: ADD SOUND EFFECT FOR THIS ELEMENT

                            $Script:TheBattleStatusMessageWindow.WriteBatElementalIce(
                                $this.PhaseOneEntity,
                                $this.PhaseTwoEntity,
                                $ToExecute,
                                $ActionResult
                            )

                            Break
                        }

                        ([BattleActionType]::MagicPoison) {
                            # TODO: ADD SOUND EFFECT FOR THIS MAGIC

                            $Script:TheBattleStatusMessageWindow.WriteBatMagicPoison(
                                $this.PhaseOneEntity,
                                $this.PhaseTwoEntity,
                                $ToExecute,
                                $ActionResult
                            )

                            Break
                        }

                        ([BattleActionType]::MagicConfuse) {
                            # TODO: ADD SOUND EFFECT FOR THIS MAGIC

                            $Script:TheBattleStatusMessageWindow.WriteBatMagicPoison(
                                $this.PhaseOneEntity,
                                $this.PhaseTwoEntity,
                                $ToExecute,
                                $ActionResult
                            )

                            Break
                        }

                        ([BattleActionType]::MagicSleep) {
                            # TODO: ADD SOUND EFFECT FOR THIS MAGIC

                            $Script:TheBattleStatusMessageWindow.WriteBatMagicSleep(
                                $this.PhaseOneEntity,
                                $this.PhaseTwoEntity,
                                $ToExecute,
                                $ActionResult
                            )

                            Break
                        }

                        ([BattleActionType]::MagicAging) {
                            # TODO: ADD SOUND EFFECT FOR THIS MAGIC

                            $Script:TheBattleStatusMessageWindow.WriteBatMagicAging(
                                $this.PhaseOneEntity,
                                $this.PhaseTwoEntity,
                                $ToExecute,
                                $ActionResult
                            )

                            Break
                        }

                        ([BattleActionType]::MagicHealing) {
                            # TODO: ADD SOUND EFFECT FOR THIS MAGIC

                            $Script:TheBattleStatusMessageWindow.WriteBatMagicHealing(
                                $this.PhaseOneEntity,
                                $this.PhaseTwoEntity,
                                $ToExecute,
                                $ActionResult
                            )

                            Break
                        }

                        ([BattleActionType]::MagicStatAugment) {
                            # TODO: ADD SOUND EFFECT FOR THIS MAGIC

                            # TODO: I'M NOT SURE I'VE CODIFIED IN THE BATTLE RESULT FOR STAT AUGS.

                            Break
                        }
                    }
                } Else {
                    # THE PHASE ONE ENTITY CAN'T ACT AT THIS TIME
                    Try {
                        $Script:TheSfxMPlayer.Open($Script:SfxBaActionDisabled)
                        $Script:TheSfxMPlayer.Play()
                    } Catch {}

                    $Script:TheBattleStatusMessageWindow.WriteEntityCantActMessage(
                        $this.PhaseOneEntity
                    )
                }

                # FACILITATE THE UPDATE OF AUGMENTS AT THE END OF THE TURN
                Foreach($Stat in $this.PhaseOneEntity.Stats.Values) {
                    $Stat.Update()
                    If($Stat.AugmentTurnDuration -EQ 0) {
                        If($this.PhaseOneEntity -IS [Player]) {
                            $Script:ThePlayerBattleStatWindow.SetAllFlagsDirty()
                            $Script:ThePlayerBattleStatWindow.Draw()
                        } Else {
                            $Script:TheEnemyBattleStatWindow.SetAllFlagsDirty()
                            $Script:TheEnemyBattleStatWindow.Draw()
                        }
                    }
                }

                # CHANGE STATE TO PHASE B
                $this.State = [BattleManagerState]::PhaseBExecution

                Break
            }

            ([BattleManagerState]::PhaseBExecution) {
                # THE SECOND OF THE NASTY BLOCKS
                # THIS IS A CARBON COPY OF PHASE A, EXCEPT THAT THE ENTITY CONSIDERED IS THE PHASETWOENTITY

                # BEFORE DOING ANYTHING, MAKE SURE THAT WE DON'T NEED TO CHANGE OUT TO THE CALCULATION STATE
                # THIS HELPS FACILITATE, PRIMARILY, THAT AN ENTITY CAN'T ACT IF THEY'RE ACTUALLY "DEAD"
                If(($this.PhaseOneEntity.Stats[[StatId]::HitPoints].Base -LE 0) -OR ($this.PhaseTwoEntity.Stats[[StatId]::HitPoints].Base -LE 0)) {
                    $this.State = [BattleManagerState]::Calculation

                    Break
                }

                # UPDATE THE PHASE INDICATOR
                $Script:TheBattlePhaseIndicator.IndicatorDrawDirty = $true
                $Script:TheBattlePhaseIndicator.Draw($this.PhaseTwoEntity)

                # ENSURE THAT THE CORRESPONDING STATUS WINDOW HAS A HIGHLIGHT AROUND THE BORDER
                If($this.PhaseTwoEntity -IS [Player]) {
                    $Script:ThePlayerBattleStatWindow.EntityBattlePhaseActive = $true
                    $Script:TheEnemyBattleStatWindow.EntityBattlePhaseActive  = $false
                } Else {
                    $Script:ThePlayerBattleStatWindow.EntityBattlePhaseActive = $false
                    $Script:TheEnemyBattleStatWindow.EntityBattlePhaseActive  = $true
                }
                $Script:ThePlayerBattleStatWindow.Draw()
                $Script:TheEnemyBattleStatWindow.Draw()

                # CHECK TO SEE IF THE PHASE TWO ENTITY CAN ACTUALLY ACT
                # REASONS THEY COULDN'T INCLUDE, BUT AREN'T LIMITED TO, STATUS AILMENTS LIKE SLEEP OR PARALYSIS
                If($this.PhaseTwoEntity.CanAct -EQ $true) {
                    [BattleAction]$ToExecute          = $null
                    [BattleActionResult]$ActionResult = $null

                    # DETERMINE IF THE PHASE TWO ENTITY IS THE PLAYER OR NOT
                    # DIFFERENT LOGIC NEEDS TO OCCUR DEPENDING UPON THIS DECISION
                    # IF IT'S THE PLAYER, WE NEED TO BLOCK LOOP ON THE BATTLE ACTION
                    # SELECTION WINDOW SO THE PLAYER CAN CHOOSE AN ATTACK TO EXECUTE.
                    If($this.PhaseTwoEntity -IS [Player]) {
                        # REFRESH THE BATTLE ACTION SELECTION WINDOW AND BLOCK LOOP ON IT
                        # THE RESULT OF THE SELECTION IS STORED IN TOEXECUTE
                        # NOTE THAT THIS IMPLEMENTATION OF HANDLEINPUT IS AN ANTI-PATTERN
                        # BUT IS REQUIRED
                        $Script:ThePlayerBattleActionWindow.SetAllActionDrawDirty()
                        While($null -EQ $ToExecute) {
                            $Script:ThePlayerBattleActionWindow.Draw()
                            $ToExecute = $Script:ThePlayerBattleActionWindow.HandleInput()
                        }

                        # THIS IS WHERE THINGS START GETTING HAIRY
                        # A LITANY OF CALLS TO WRITECOMPOSITEMESSAGE ON THE BATTLESTATUSMESSAGEWINDOW
                        # OCCUR FOLLOWING. I'M GOING TO ATTEMPT TO CONDENSE THESE CALLS.
                        $Script:TheBattleStatusMessageWindow.WriteEntityUsesMessage(
                            $this.PhaseTwoEntity,
                            $this.PhaseOneEntity,
                            $ToExecute
                        )

                        # ACTUALLY EXECUTE THE SELECTED COMMAND
                        # PS DOES SOME GOOFY SHIT WITH DISPATCHING THESE CALLS TO ICM, BUT THIS HASN'T CAUSED ANY PROBLEMS AFTER MANY HOURS
                        # OF TESTING THUS FAR.
                        $ActionResult = $(Invoke-Command $ToExecute.Effect -ArgumentList $this.PhaseTwoEntity, $this.PhaseOneEntity, $ToExecute)

                        # REFRESH THE PLAYER BATTLE STATUS WINDOW
                        $Script:ThePlayerBattleStatWindow.Draw()
                    } Else {
                        # THE PHASE TWO ENTITY IS THE ENEMY
                        # THE ACTION THE ENEMY USES IS SELECTED FROM THE "MARBLE BAG", SO NO DELAY IS NEEDED HERE.
                        [ActionSlot]$SelectedSlot = $($this.PhaseTwoEntity.ActionMarbleBag | Get-Random)
                        $ToExecute                = $this.PhaseTwoEntity.ActionListing[$SelectedSlot]

                        # NOTIFY THE BATTLE STATUS MESSAGE WINDOW
                        $Script:TheBattleStatusMessageWindow.WriteEntityUsesMessage(
                            $this.PhaseTwoEntity,
                            $this.PhaseOneEntity,
                            $ToExecute
                        )

                        # EXECUTE THE ACTION AND UPDATE THE ENEMY'S BATTLE STATUS WINDOW
                        $ActionResult = $(Invoke-Command $ToExecute.Effect -ArgumentList $this.PhaseTwoEntity, $this.PhaseOneEntity, $ToExecute)
                        $Script:TheEnemyBattleStatWindow.Draw()
                    }

                    # WE NEED TO EXAMINE THE ACTION RESULT TO SEE WHAT HAPPENED AS A CONSEQUENCE OF RUNNING THE SELECTED ACTION
                    # THIS IS DONE FIRST BY LOOKING AT THE VALUE OF THE TYPE PROPERTY
                    Switch($ActionResult.Type) {
                        ([BattleActionResultType]::SuccessWithCritical) {
                            $Script:TheBattleStatusMessageWindow.WriteBarSwc($ToExecute)

                            Break
                        }

                        ([BattleActionResultType]::SuccessWithAffinityBonus) {
                            $Script:TheBattleStatusMessageWindow.WriteBarAff($ToExecute)

                            Break
                        }

                        ([BattleActionResultType]::SuccessWithCritAndAffinityBonus) {
                            $Script:TheBattleStatusMessageWindow.WriteBarCritAff($ToExecute)

                            Break
                        }

                        ([BattleActionResultType]::Success) {
                            $Script:TheBattleStatusMessageWindow.WriteBarSuccess($ToExecute)

                            Break
                        }

                        ([BattleActionResultType]::FailedAttackMissed) {
                            Try {
                                $Script:TheSfxMPlayer.Open($Script:SfxBaMissFail)
                                $Script:TheSfxMPlayer.Play()
                            } Catch {}

                            $Script:TheBattleStatusMessageWindow.WriteBarFailMissed($ToExecute)

                            Break
                        }

                        ([BattleActionResultType]::FailedAttackFailed) {
                            Try {
                                $Script:TheSfxMPlayer.Open($Script:SfxBaMissFail)
                                $Script:TheSfxMPlayer.Play()
                            } Catch {}

                            $Script:TheBattleStatusMessageWindow.WriteBarFailFailed($ToExecute)

                            Break
                        }
                    }

                    # NEXT WE NEED TO EXAMINE THE TYPE OF THE ACTION EXECUTED TO DO PROVIDE SOME
                    # ADDITIONAL FEEDBACK
                    Switch($ToExecute.Type) {
                        ([BattleActionType]::Physical) {
                            Try {
                                $Script:TheSfxMPlayer.Open($Script:SfxBaPhysicalStrikeA)
                                $Script:TheSfxMPlayer.Play()
                            } Catch {}

                            $Script:TheBattleStatusMessageWindow.WriteBatPhysical(
                                $this.PhaseTwoEntity,
                                $this.PhaseOneEntity,
                                $ToExecute,
                                $ActionResult
                            )

                            Break
                        }

                        ([BattleActionType]::ElementalFire) {
                            Try {
                                $Script:TheSfxMPlayer.Open($Script:SfxBaFireStrikeA)
                                $Script:TheSfxMPlayer.Play()
                            } Catch {}

                            $Script:TheBattleStatusMessageWindow.WriteBatElementalFire(
                                $this.PhaseTwoEntity,
                                $this.PhaseOneEntity,
                                $ToExecute,
                                $ActionResult
                            )

                            Break
                        }

                        ([BattleActionType]::ElementalWater) {
                            # TODO: ADD SOUND EFFECT FOR THIS ELEMENT

                            $Script:TheBattleStatusMessageWindow.WriteBatElementalWater(
                                $this.PhaseTwoEntity,
                                $this.PhaseOneEntity,
                                $ToExecute,
                                $ActionResult
                            )

                            Break
                        }

                        ([BattleActionType]::ElementalEarth) {
                            # TODO: ADD SOUND EFFECT FOR THIS ELEMENT

                            $Script:TheBattleStatusMessageWindow.WriteBatElementalEarth(
                                $this.PhaseTwoEntity,
                                $this.PhaseOneEntity,
                                $ToExecute,
                                $ActionResult
                            )

                            Break
                        }

                        ([BattleActionType]::ElementalWind) {
                            # TODO: ADD SOUND EFFECT FOR THIS ELEMENT

                            $Script:TheBattleStatusMessageWindow.WriteBatElementalWind(
                                $this.PhaseTwoEntity,
                                $this.PhaseOneEntity,
                                $ToExecute,
                                $ActionResult
                            )

                            Break
                        }

                        ([BattleActionType]::ElementalLight) {
                            # TODO: ADD SOUND EFFECT FOR THIS ELEMENT

                            $Script:TheBattleStatusMessageWindow.WriteBatElementalLight(
                                $this.PhaseTwoEntity,
                                $this.PhaseOneEntity,
                                $ToExecute,
                                $ActionResult
                            )

                            Break
                        }

                        ([BattleActionType]::ElementalDark) {
                            # TODO: ADD SOUND EFFECT FOR THIS ELEMENT

                            $Script:TheBattleStatusMessageWindow.WriteBatElementalDark(
                                $this.PhaseTwoEntity,
                                $this.PhaseOneEntity,
                                $ToExecute,
                                $ActionResult
                            )

                            Break
                        }

                        ([BattleActionType]::ElementalIce) {
                            # TODO: ADD SOUND EFFECT FOR THIS ELEMENT

                            $Script:TheBattleStatusMessageWindow.WriteBatElementalIce(
                                $this.PhaseTwoEntity,
                                $this.PhaseOneEntity,
                                $ToExecute,
                                $ActionResult
                            )

                            Break
                        }

                        ([BattleActionType]::MagicPoison) {
                            # TODO: ADD SOUND EFFECT FOR THIS MAGIC

                            $Script:TheBattleStatusMessageWindow.WriteBatMagicPoison(
                                $this.PhaseTwoEntity,
                                $this.PhaseOneEntity,
                                $ToExecute,
                                $ActionResult
                            )

                            Break
                        }

                        ([BattleActionType]::MagicConfuse) {
                            # TODO: ADD SOUND EFFECT FOR THIS MAGIC

                            $Script:TheBattleStatusMessageWindow.WriteBatMagicPoison(
                                $this.PhaseTwoEntity,
                                $this.PhaseOneEntity,
                                $ToExecute,
                                $ActionResult
                            )

                            Break
                        }

                        ([BattleActionType]::MagicSleep) {
                            # TODO: ADD SOUND EFFECT FOR THIS MAGIC

                            $Script:TheBattleStatusMessageWindow.WriteBatMagicSleep(
                                $this.PhaseTwoEntity,
                                $this.PhaseOneEntity,
                                $ToExecute,
                                $ActionResult
                            )

                            Break
                        }

                        ([BattleActionType]::MagicAging) {
                            # TODO: ADD SOUND EFFECT FOR THIS MAGIC

                            $Script:TheBattleStatusMessageWindow.WriteBatMagicAging(
                                $this.PhaseTwoEntity,
                                $this.PhaseOneEntity,
                                $ToExecute,
                                $ActionResult
                            )

                            Break
                        }

                        ([BattleActionType]::MagicHealing) {
                            # TODO: ADD SOUND EFFECT FOR THIS MAGIC

                            $Script:TheBattleStatusMessageWindow.WriteBatMagicHealing(
                                $this.PhaseTwoEntity,
                                $this.PhaseOneEntity,
                                $ToExecute,
                                $ActionResult
                            )

                            Break
                        }

                        ([BattleActionType]::MagicStatAugment) {
                            # TODO: ADD SOUND EFFECT FOR THIS MAGIC

                            # TODO: I'M NOT SURE I'VE CODIFIED IN THE BATTLE RESULT FOR STAT AUGS.

                            Break
                        }
                    }
                } Else {
                    # THE PHASE ONE ENTITY CAN'T ACT AT THIS TIME
                    Try {
                        $Script:TheSfxMPlayer.Open($Script:SfxBaActionDisabled)
                        $Script:TheSfxMPlayer.Play()
                    } Catch {}

                    $Script:TheBattleStatusMessageWindow.WriteEntityCantActMessage(
                        $this.PhaseTwoEntity
                    )
                }

                # FACILITATE THE UPDATE OF AUGMENTS AT THE END OF THE TURN
                Foreach($Stat in $this.PhaseTwoEntity.Stats.Values) {
                    $Stat.Update()
                    If($Stat.AugmentTurnDuration -EQ 0) {
                        If($this.PhaseOneEntity -IS [Player]) {
                            $Script:ThePlayerBattleStatWindow.SetAllFlagsDirty()
                            $Script:ThePlayerBattleStatWindow.Draw()
                        } Else {
                            $Script:TheEnemyBattleStatWindow.SetAllFlagsDirty()
                            $Script:TheEnemyBattleStatWindow.Draw()
                        }
                    }
                }

                # CHANGE STATE TO TURN INCREMENT
                $this.State = [BattleManagerState]::TurnIncrement

                Break
            }

            ([BattleManagerState]::Calculation) {
                # GIVEN HOW THIS STATE IS ENTERED, THIS MAY BE A REDUNDANT CHECK, BUT I DON'T CARE
                If($this.PhaseOneEntity.Stats[[StatId]::HitPoints].Base -LE 0) {
                    If($this.PhaseOneEntity -IS [Player]) {
                        $this.State = [BattleManagerState]::BattleLost

                        Break
                    } Else {
                        # $this.SpoilsAction = $this.PhaseTwoEntity.SpoilsEffect
                        $this.State = [BattleManagerState]::BattleWon

                        Break
                    }
                } Elseif($this.PhaseTwoEntity.Stats[[StatId]::HitPoints].Base -LE 0) {
                    If($this.PhaseTwoEntity -IS [Player]) {
                        $this.State = [BattleManagerState]::BattleLost

                        Break
                    } Else {
                        # $this.SpoilsAction = $this.PhaseOneEntity.SpoilsEffect
                        $this.State = [BattleManagerState]::BattleWon

                        Break
                    }
                }

                # DO NOTHING, TRANSITION BACK TO TURN INCREMENT STATE
                $this.State = [BattleManagerState]::BattleWon

                Break
            }

            ([BattleManagerState]::BattleWon) {
                $Script:TheBgmMPlayer.Stop() # STOP PLAYING THE BATTLE BGM
                
                # CHECK TO SEE IF THE BATTLE WON CHIME HAS PLAYED
                # PLAY IT IF IT HASN'T
                If($Script:HasBattleWonChimePlayed -EQ $false) {
                    Try {
                        $Script:TheSfxMPlayer.Open($Script:SfxBattlePlayerWin)
                        $Script:TheSfxMPlayer.Play()
                    } Catch {}
                    $Script:HasBattleWonChimePlayed = $true
                }

                # THE FOLLOWING CODE WILL WRITE TWO OUT-OF-BAND MESSAGES TO THE STATUS WINDOW
                # OUT-OF-BAND MEANING THAT EXPLICIT CALLS TO THE DRAW FUNCTION ARE MADE BECAUSE
                # THE NORMAL SEQUENCING WOULD CAUSE THESE TO NOT BE DRAWN IN TIME
                
                # WRITE THE WON MESSAGE TO THE STATUS WINDOW
                $Script:TheBattleStatusMessageWindow.WriteBattleWonMessage()
                $Script:TheBattleStatusMessageWindow.Draw()

                # RUN THE SPOILS EFFECT; NEED TO DETERMINE WHICH ENTITY IS THE PLAYER
                If($this.PhaseOneEntity -IS [Player]) {
                    # THE ORIGINAL CODE RESET THE SPOILSACTION MEMBER; NOT SURE WHY
                    # THE LIKELY CAUSE IS I'M AN IDIOT
                    Invoke-Command $this.PhaseTwoEntity.SpoilsEffect -ArgumentList ([Player]$this.PhaseOneEntity), ([EnemyBattleEntity]$this.PhaseTwoEntity)
                } Elseif($this.PhaseTwoEntity -IS [Player]) {
                    Invoke-Command $this.PhaseOneEntity.SpoilsEffect -ArgumentList ([Player]$this.PhaseTwoEntity), ([EnemyBattleEntity]$this.PhaseOneEntity)
                }

                # WRITE THE BATTLE END PROMPT
                $Script:TheBattleStatusMessageWindow.WriteBattleEndPrompt()
                $Script:TheBattleStatusMessageWindow.Draw()

                # BLOCK FOR THE ENTER KEY (ACKSHUALEE ENTER KEY)
                $a = $Script:Rui.ReadKey('IncludeKeyDown, NoEcho')
                While($a.VirtualKeyCode -NE 13) {
                    $a = $Script:Rui.ReadKey('IncludeKeyDown, NoEcho')
                }

                # CHANGE GLOBAL STATE
                $Script:ThePreviousGlobalGameState = $Script:TheGlobalGameState
                $Script:TheGlobalGameState         = [GameStatePrimary]::GamePlayScreen

                Break
            }

            ([BattleManagerState]::BattleLost) {
				$Script:TheBgmMPlayer.Stop() # STOP PLAYING THE BATTLE BGM
				
				# CHECK TO SEE IF THE BATTLE LOST CHIME HAS PLAYED
				# PLAY IT IF IT HASN'T
				If($Script:HasBattleLostChimePlayed -EQ $false) {
					Try {
						$Script:TheSfxMPlayer.Open($Script:SfxBattlePlayerLose)
						$Script:TheSfxMPlayer.Play()
					} Catch {}
					$Script:HasBattleLostChimPlayed = $true
				}
				
				# WRITE THE LOST MESSAGE TO THE STATUS WINDOW
				$Script:TheBattleStatusMessageWindow.WriteBattleLostMessage()
				$Script:TheBattleStatusMessageWindow.Draw()
				$Script:TheBattleStatusMessageWindow.WriteGameOverMessage()
				$Script:TheBattleStatusMessageWindow.Draw()
				
				# SLEEP THEN DIE
				Start-Sleep -Seconds 5
				Clear-Host
				
				Exit
			}

            Default {}
        }
    }

    [Void]Cleanup() {
        $Script:BattleCursorVisible          = $false
        $Script:HasBattleIntroPlayed         = $false
        $Script:IsBattleBgmPlaying           = $false
        $Script:HasBattleWonChimePlayed      = $false
        $Script:HasBattleLostChimePlayed     = $false
    }
}
