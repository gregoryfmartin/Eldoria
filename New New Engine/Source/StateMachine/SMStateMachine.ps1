using namespace System
using namespace System.Collections.Generic

Set-StrictMode -Version Latest





###############################################################################
#
# FINITE STATE MACHINE IMPLEMENTATION
#
# SMSTATEMACHINE
#
# THE STATE MACHINE DEFINITION.
#
#
#
# USAGE SAMPLE
#
# 1. INITIALIZE THE STATE MACHINE WITH A STARTING STATE
# $Turnstile = [SMStateMachine]::new("Locked")
#
# # 2. DEFINE THE STATES AND THEIR ENTRY/EXIT BEHAVIORS
# $LockedState = [SMState]::new(
#     "Locked", 
#     { Write-Host "[STATE] The turnstile is locked." -ForegroundColor Red }, 
#     $null # NO SPECIFIC EXIT ACTION
# )
#
# $UnlockedState = [SMState]::new(
#     "Unlocked", 
#     { Write-Host "[STATE] The turnstile is unlocked! You may pass." -ForegroundColor Green },
#     { Write-Host "[EXIT] You passed through." -ForegroundColor DarkGray }
# )
#
# $Turnstile.AddState($LockedState)
# $Turnstile.AddState($UnlockedState)
#
# # 3. DEFINE THE TRANSITIONS
# $Turnstile.AddTransition([SMTransition]::new("Locked", "InsertCoin", "Unlocked", { Write-Host "*Clink* Coin accepted." }))
# $Turnstile.AddTransition([SMTransition]::new("Locked", "Push", "Locked", { Write-Host "You push against the locked turnstile. Nothing happens." }))
# $Turnstile.AddTransition([SMTransition]::new("Unlocked", "Push", "Locked"))
# $Turnstile.AddTransition([SMTransition]::new("Unlocked", "InsertCoin", "Unlocked", { Write-Host "Coin rejected. Turnstile is already unlocked." }))
#
# # 4. RUN THE MACHINE
# Write-Host "--- Start Simulation ---" -ForegroundColor Cyan
# Write-Host "Current State: $($turnstile.CurrentState)"
#
# Write-Host "`n>> Event: Push" -ForegroundColor Yellow
# $Turnstile.Trigger("Push")
#
# Write-Host "`n>> Event: InsertCoin" -ForegroundColor Yellow
# $Turnstile.Trigger("InsertCoin")
#
# Write-Host "`n>> Event: InsertCoin" -ForegroundColor Yellow
# $Turnstile.Trigger("InsertCoin")
#
# Write-Host "`n>> Event: Push" -ForegroundColor Yellow
# $Turnstile.Trigger("Push")
#
###############################################################################

Class SMStateMachine {
    [String]$CurrentState
    [Dictionary[String, SMState]]$States
    [List[SMTransition]]$Transitions

    SMStateMachine(
        [String]$InitialState
    ) {
        $this.CurrentState = $InitialState
        $this.States       = [Dictionary[String, SMState]]::new()
        $this.Transitions  = [List[SMTransition]]::new()
    }

    [Void]AddState(
        [SMState]$State
    ) {
        $this.States[$State.Name] = $State
    }

    [Void]AddStates(
        [SMState[]]$States
    ) {
        Foreach($State in $States) {
            $this.States[$State.Name] = $State
        }
    }

    [Void]AddTransition(
        [SMTransition]$Transition
    ) {
        $this.Transitions.Add($Transition)
    }

    [Void]AddTransitions(
        [SMTransition[]]$Transitions
    ) {
        Foreach($Transition in $Transitions) {
            $this.Transitions.Add($Transition)
        }
    }

    [Void]Update(
        [Context]$Context
    ) {
        # EACH CALL IS EXPECTED TO HAVE A CONTEXT ASSOCIATED WITH IT FOR DI
        [SMState]$CurrentStateObject = $this.States[$this.CurrentState]

        If($null -NE $CurrentStateObject -AND $null -NE $CurrentStateObject.OnUpdate) {
            $CurrentStateObject.OnUpdate.Invoke(@($Context))
        }
    }

    [Void]Trigger(
        [String]$StateEvent,
        [Context]$Context
    ) {
        # FIND A VALID TRANSITION FOR THE CURRENT STATE AND EVENT
        $ValidTransition = $null
        Foreach($Transition in $this.Transitions) {
            If($Transition.FromState -EQ $this.CurrentState -AND $Transition.UserEvent -EQ $StateEvent) {
                $ValidTransition = $Transition

                Break
            }
        }

        # HANDLE INVALID EVENTS
        If($null -EQ $ValidTransition) {
            Write-Warning "Event '$StateEvent' is not valid for current state '$($this.CurrentState)'."

            return
        }

        $NextStateName   = $ValidTransition.ToState
        $CurrentStateObj = $this.States[$this.CurrentState]
        $NextStateObj    = $this.States[$NextStateName]

        # STEP 1: EXECUTE ONEXIT FOR THE CURRENT STATE
        If($null -NE $CurrentStateObj -AND $null -NE $CurrentStateObj.OnExit) {
            $CurrentStateObj.OnExit.Invoke($Context)
        }

        # STEP 2: EXECUTE TRANSITION SPECIFIC ACTION (IF ANY)
        If($null -NE $ValidTransition.Action) {
            $ValidTransition.Action.Invoke($Context)
        }

        # STEP 3: CHANGE THE CURRENT STATE
        $this.CurrentState = $NextStateName

        # STEP 4: EXECUTE ONENTER FOR THE NEW STATE
        If($null -NE $NextStateObj -AND $null -NE $NextStateObj.OnEnter) {
            $NextStateObj.OnEnter.Invoke($Context)
        }
    }
}
