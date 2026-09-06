using namespace System
using namespace System.Collections.Generic

Set-StrictMode -Version Latest





###############################################################################
#
# UIBASE
#
# THE BASE COMPONENT FOR ALL USER INTERFACE OBJECTS.
#
###############################################################################

# Class UIBaseInit : SMState {
#     UIBaseInit() : base('UIBaseInit') {
#         $this.OnEnter = {
#             # THIS DOESN'T GET CALLED DUE TO BEING THE INITIAL STATE
#             # I NEVER DID FIX THAT BUG
#         }

#         $this.OnExit = {
#             Param(
#                 [Context]$Context
#             )

#             # CONTEXT MAPPING HERE:
#             # 0 - UIBASE
#             $Context.References[0].Publish('UIBaseInit_OnExit', $Context)
#         }

#         $this.OnUpdate = {
#             Param(
#                 [Context]$Context
#             )

#             # CONTEXT MAPPING HERE:
#             # 0 - UIBASE
#             $Context.References[0].Publish('UIBaseInit_OnUpdate', $Context)
#         }
#     }
# }

# Class UIBaseDeinit : SMState {
#     UIBaseDeinit() : base('UIBaseDeinit') {
#         $this.OnEnter = {
#             Param(
#                 [Context]$Context
#             )

#             # CONTEXT MAPPING HERE:
#             # 0 - UIBASE
#             $Context.References[0].Publish('UIBaseDeinit_OnEnter', $Context)
#         }

#         $this.OnExit = {
#             Param(
#                 [Context]$Context
#             )

#             # CONTEXT MAPPING HERE:
#             # 0 - UIBASE
#             $Context.References[0].Publish('UIBaseDeinit_OnExit', $Context)
#         }

#         $this.OnUpdate = {
#             Param(
#                 [Context]$Context
#             )

#             # CONTEXT MAPPING HERE:
#             # 0 - UIBASE
#             $Context.References[0].Publish('UIBaseDeinit_OnUpdate', $Context)
#         }
#     }
# }

# Class UIBaseActive : SMState {
#     UIBaseActive() : base('UIBaseActive') {
#         $this.OnEnter = {
#             Param(
#                 [Context]$Context
#             )

#             # CONTEXT MAPPING HERE:
#             # 0 - UIBASE
#             $Context.References[0].Publish('UIBaseActive_OnEnter', $Context)
#         }

#         $this.OnExit = {
#             Param(
#                 [Context]$Context
#             )

#             # CONTEXT MAPPING HERE:
#             # 0 - UIBASE
#             $Context.References[0].Publish('UIBaseActive_OnExit', $Context)
#         }

#         $this.OnUpdate = {
#             Param(
#                 [Context]$Context
#             )

#             # CONTEXT MAPPING HERE:
#             # 0 - UIBASE
#             $Context.References[0].Publish('UIBaseActive_OnUpdate', $Context)
#         }
#     }
# }

# Class UIBaseInactive : SMState {
#     UIBaseInactive() : base('UIBaseInactive') {
#         $this.OnEnter = {
#             Param(
#                 [Context]$Context
#             )

#             # CONTEXT MAPPING HERE:
#             # 0 - UIBASE
#             $Context.References[0].Publish('UIBaseInactive_OnEnter', $Context)
#         }

#         $this.OnExit = {
#             Param(
#                 [Context]$Context
#             )

#             # CONTEXT MAPPING HERE:
#             # 0 - UIBASE
#             $Context.References[0].Publish('UIBaseInactive_OnExit', $Context)
#         }

#         $this.OnUpdate = {
#             Param(
#                 [Context]$Context
#             )

#             # CONTEXT MAPPING HERE:
#             # 0 - UIBASE
#             $Context.References[0].Publish('UIBaseInactive_OnUpdate', $Context)
#         }
#     }
# }

# Class UIBaseFocused : SMState {
#     UIBaseFocused() : base('UIBaseFocused') {
#         $this.OnEnter = {
#             Param(
#                 [Context]$Context
#             )

#             # CONTEXT MAPPING HERE:
#             # 0 - UIBASE
#             $Context.References[0].Publish('UIBaseFocused_OnEnter', $Context)
#         }

#         $this.OnExit = {
#             Param(
#                 [Context]$Context
#             )

#             # CONTEXT MAPPING HERE:
#             # 0 - UIBASE
#             $Context.References[0].Publish('UIBaseFocused_OnExit', $Context)
#         }

#         $this.OnUpdate = {
#             Param(
#                 [Context]$Context
#             )

#             # CONTEXT MAPPING HERE:
#             # 0 - UIBASE
#             $Context.References[0].Publish('UIBaseFocused_OnUpdate', $Context)
#         }
#     }
# }

Class UIBase : ATString {
    [String]$Blank
    [Boolean]$Dirty
    [UIElementBehavior]$Behavior

    # [SMStateMachine]$BaseStateMachine
    [SMUiElementStateMachine]$BaseStateMachine
    [Dictionary[String, List[ScriptBlock]]]$StateEvents

    # [Boolean]$CanHaveFocus
    # [Boolean]$HasFocus
    # [Boolean]$Active
    
    UIBase() : base() {
        $this.Dirty            = $false
        $this.Blank            = ' '
        $this.Prefix           = [ATStringPrefix]::new()                         # FIXES A SMALL BUGGY
        $this.Behavior         = [UIElementBehavior]::new()
        $this.StateEvents      = [Dictionary[String, List[ScriptBlock]]]::new()
        $this.BaseStateMachine = [SMUiElementStateMachine]::new()

<#
        $this.BaseStateMachine.AddStates(@(
            [UIBaseInit]::new(),
            [UIBaseDeinit]::new(),
            [UIBaseActive]::new(),
            [UIBaseInactive]::new(),
            [UIBaseFocused]::new()
        ))

        $this.BaseStateMachine.AddTransitions(@(
            [SMTransition]::new(
                'UIBaseInit',
                'Ready',
                'UIBaseInactive'
            ),
            [SMTransition]::new(
                'UIBaseInactive',
                'Activate',
                'UIBaseActive'
            ),
            [SMTransition]::new(
                'UIBaseActive',
                'Deactivate',
                'UIBaseInactive'
            ),
            [SMTransition]::new(
                'UIBaseActive',
                'Focus',
                'UIBaseFocused'
            ),
            [SMTransition]::new(
                'UIBaseFocused',
                'Unfocus',
                'UIBaseActive'
            ),
            [SMTransition]::new(
                'UIBaseFocused',
                'Deactivate',
                'UIBaseInactive'
            ),
            [SMTransition]::new(
                'UIBaseInactive',
                'Deinit',
                'UIBaseDeinit'
            ),
            [SMTransition]::new(
                'UIBaseActive',
                'Deinit',
                'UIBaseDeinit'
            ),
            [SMTransition]::new(
                'UIBaseFocused',
                'Deinit',
                'UIBaseDeinit'
            ),
            [SMTransition]::new(
                'UIBaseInit',
                'Deinit',
                'UIBaseDeinit'
            )
        ))

        $this.Subscribe(
            'UIBaseInit_OnUpdate',
            {
                Param(
                    [Context]$Context
                )

                [UIBase]$SelfElement = $Context.References[0]
                
                $SelfElement.BaseStateMachine.Trigger('Ready', $Context)
            }
        )
#>
        
        $this.Subscribe(
            'SMUiElementInit_OnUpdate',
            {
                Param(
                    [Context]$Context
                )

                [UIBase]$SelfElement = $Context.References[0]

                $SelfElement.BaseStateMachine.Trigger([SMUiElementStateMachine]::TransitionReady, $Context)
            }
        )
    }

    [Void]Activate(
        [Context]$Context
    ) {
        # TRIGGER A CHANGE WITH THE STATE MACHINE
        # TO MOVE TO THE ACTIVE STATE
        # $this.BaseStateMachine.Trigger('Activate', $Context)
        $this.BaseStateMachine.Trigger([SMUiElementStateMachine]::TransitionActivate, $Context)
    }

    [Void]Deactivate(
        [Context]$Context
    ) {
        # TRIGGER A CHANGE WITH THE STATE MACHINE
        # TO MOVE TO THE INACTIVE STATE
        # $this.BaseStateMachine.Trigger('Deactivate', $Context)
        $this.BaseStateMachine.Trigger([SMUiElementStateMachine]::TransitionDeactivate, $Context)
    }

    [Void]Focus(
        [Context]$Context
    ) {
        # TRIGGER A CHANGE WITH THE STATE MACHINE
        # TO MOVE TO THE FOCUSED STATE
        # $this.BaseStateMachine.Trigger('Focus', $Context)
        $this.BaseStateMachine.Trigger([SMUiElementStateMachine]::TransitionFocus, $Context)
    }

    [Void]Unfocus(
        [Context]$Context
    ) {
        # TRIGGER A CHANGE WITH THE STATE MACHINE
        # TO MOVE TO THE ACTIVE STATE
        # $this.BaseStateMachine.Trigger('Unfocus', $Context)
        $this.BaseStateMachine.Trigger([SMUiElementStateMachine]::TransitionUnfocus, $Context)
    }

    [Void]Deinit(
        [Context]$Context
    ) {
        # TRIGGER A CHANGE WITH THE STATE MACHINE
        # TO MOVE TO THE DEINIT STATE
        # $this.BaseStateMachine.Trigger('Deinit', $Context)
        $this.BaseStateMachine.Trigger([SMUiElementStateMachine]::TransitionDeinit, $Context)
    }

    [Void]ToggleFocus() {}

    [Void]ToggleActive() {
        # If($this.Behavior.Active -EQ $true) {
        #     $this.Behavior.Active = $false

        #     Return
        # } Else {
        #     $this.Behavior.Active = $true

        #     Return
        # }
    }

    [Void]Subscribe(
        [String]$EventName,
        [ScriptBlock]$Action
    ) {
        If($this.StateEvents.ContainsKey($EventName) -EQ $false) {
            $this.StateEvents[$EventName] = [List[ScriptBlock]]::new()
        }
        $this.StateEvents[$EventName].Add($Action)
    }

    [Void]Subscribe(
        [Hashtable]$SubListing
    ) {
        Foreach($Sub in $SubListing.GetEnumerator()) {
            If($this.StateEvents.ContainsKey($Sub.Key) -EQ $false) {
                $this.StateEvents[$Sub.Key] = [List[ScriptBlock]]::new()
            }
            $this.StateEvents[$Sub.Key].Add($Sub.Value)
        }
    }

    [Void]Publish(
        [String]$EventName,
        [Context]$Context
    ) {
        If($this.StateEvents.ContainsKey($EventName) -EQ $true) {
            Foreach($Action in $this.StateEvents[$EventName]) {
                $Action.Invoke($Context)
            }
        }
    }

    [Void]Update(
        [Context]$Context
    ) {
        $this.BaseStateMachine.Update($Context)
    }
    
    [Void]SetUserData(
        [String]$UserData
    ) {
        If(($null -NE $UserData) -AND ($UserData.Length -GT 0)) {
            If($this.Blank.Length -LT $UserData.Length) {
                $this.SetBlankSize($UserData.Length)
            }
            $this.UserData = $UserData
        }
    }
    
    [Void]SetBlankSize(
        [Int]$Size
    ) {
        If($Size -LE 0) {
            $this.Blank = ' '
        } Else {
            $this.Blank = ' ' * $Size
        }
    }
    
    [String]ToAnsiControlSequenceString() {
        Return "$($this.Prefix.Coordinates.ToAnsiControlSequenceString())$($this.Blank)$(([ATString]$this).ToAnsiControlSequenceString())"
    }
    
    [Void]Draw() {
        If($this.Dirty -EQ $true) {
            Write-Host "$($this.ToAnsiControlSequenceString())"
            
            $this.Dirty = $false
        }
    }
}
