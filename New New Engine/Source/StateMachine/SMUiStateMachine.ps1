using namespace System

Set-StrictMode -Version Latest





###############################################################################
#
# SM UIELEMENT INIT
#
###############################################################################

Class SMUiElementInit : SMState {
    SMUiElementInit() : base('SMUiElementInit') {
        $this.OnEnter = {}

        $this.OnExit = {
            Param(
                [Context]$Context
            )

            # CONTEXT MAPPING:
            # 0 - UIBASE
            $Context.References[0].Publish('SMUiElementInit_OnExit', $Context)
        }

        $this.OnUpdate = {
            Param(
                [Context]$Context
            )

            # CONTEXT MAPPING:
            # 0 - UIBASE
            $Context.References[0].Publish('SMUiElementInit_OnUpdate', $Context)
        }
    }
}





###############################################################################
#
# SM UIELEMENT DEINIT
#
###############################################################################

Class SMUiElementDeinit : SMState {
    SMUiElementDeinit() : base('SMUiElementDeinit') {
        $this.OnEnter = {
            Param(
                [Context]$Context
            )

            # CONTEXT MAPPING
            # 0 - UIBASE
            $Context.References[0].Publish('SMUiElementDeinit_OnEnter', $Context)
        }

        $this.OnExit = {
            Param(
                [Context]$Context
            )

            # CONTEXT MAPPING
            # 0 - UIBASE
            $Context.References[0].Publish('SMUiElementDeinit_OnExit', $Context)
        }

        $this.OnUpdate = {
            Param(
                [Context]$Context
            )

            # CONTEXT MAPPING
            # 0 - UIBASE
            $Context.References[0].Publish('SMUiElementDeinit_OnUpdate', $Context)
        }
    }
}





###############################################################################
#
# SM UIELEMENT ACTIVE
#
###############################################################################

Class SMUiElementActive : SMState {
    SMUiElementActive() : base('SMUiElementActive') {
        $this.OnEnter = {
            Param(
                [Context]$Context
            )

            # CONTEXT MAPPING
            # 0 - UIBASE
            $Context.References[0].Publish('SMUiElementActive_OnEnter', $Context)
        }

        $this.OnExit = {
            Param(
                [Context]$Context
            )

            # CONTEXT MAPPING
            # 0 - UIBASE
            $Context.References[0].Publish('SMUiElementActive_OnExit', $Context)
        }

        $this.OnUpdate = {
            Param(
                [Context]$Context
            )

            # CONTEXT MAPPING
            # 0 - UIBASE
            $Context.References[0].Publish('SMUiElementActive_OnUpdate', $Context)
        }
    }
}





###############################################################################
#
# SM UIELEMENT INACTIVE
#
###############################################################################

Class SMUiElementInactive : SMState {
    SMUiElementInactive() : base('SMUiElementInactive') {
        $this.OnEnter = {
            Param(
                [Context]$Context
            )

            # CONTEXT MAPPING
            # 0 - UIBASE
            $Context.References[0].Publish('SMUiElementInactive_OnEnter', $Context)
        }

        $this.OnExit = {
            Param(
                [Context]$Context
            )

            # CONTEXT MAPPING
            # 0 - UIBASE
            $Context.References[0].Publish('SMUiElementInactive_OnExit', $Context)
        }

        $this.OnUpdate = {
            Param(
                [Context]$Context
            )

            # CONTEXT MAPPING
            # 0 - UIBASE
            $Context.References[0].Publish('SMUiElementInactive_OnUpdate', $Context)
        }
    }
}





###############################################################################
#
# SM UIELEMENT FOCUSED
#
###############################################################################

Class SMUiElementFocused : SMState {
    SMUiElementFocused() : base('SMUiElementFocused') {
        $this.OnEnter = {
            Param(
                [Context]$Context
            )

            # CONTEXT MAPPING
            # 0 - UIBASE
            $Context.References[0].Publish('SMUiElementFocused_OnEnter', $Context)
        }

        $this.OnExit = {
            Param(
                [Context]$Context
            )

            # CONTEXT MAPPING
            # 0 - UIBASE
            $Context.References[0].Publish('SMUiElementFocused_OnExit', $Context)
        }

        $this.OnUpdate = {
            Param(
                [Context]$Context
            )

            # CONTEXT MAPPING
            # 0 - UIBASE
            $Context.References[0].Publish('SMUiElementFocused_OnUpdate', $Context)
        }
    }
}





###############################################################################
#
# SM UI ELEMENT STATE MACHINE
#
# A STATE MACHINE INTENDED TO BE USED SPECIFICALLY BY UI ELEMENTS.
#
###############################################################################

Class SMUiElementStateMachine : SMStateMachine {
    Static [String]$TransitionReady      = 'Ready'
    Static [String]$TransitionActivate   = 'Activate'
    Static [String]$TransitionDeactivate = 'Deactivate'
    Static [String]$TransitionFocus      = 'Focus'
    Static [String]$TransitionUnfocus    = 'Unfocus'
    Static [String]$TransitionDeinit     = 'Deinit'
    Static [String]$StateInit            = 'SMUiElementInit'
    Static [String]$StateInactive        = 'SMUiElementInactive'
    Static [String]$StateActive          = 'SMUiElementActive'
    Static [String]$StateFocused         = 'SMUiElementFocused'
    Static [String]$StateDeinit          = 'SMUiElementDeinit'

    SMUiElementStateMachine() : base('SMUiElementInit') {
        $this.AddStates(@(
            [SMUiElementInit]::new(),
            [SMUiElementDeinit]::new(),
            [SMUiElementInactive]::new(),
            [SMUiElementActive]::new(),
            [SMUiElementFocused]::new()
        ))

        $this.AddTransitions(@(
            [SMTransition]::new(
                [SMUiElementStateMachine]::StateInit,
                [SMUiElementStateMachine]::TransitionReady,
                [SMUiElementStateMachine]::StateInactive
            ),
            [SMTransition]::new(
                [SMUiElementStateMachine]::StateInactive,
                [SMUiElementStateMachine]::TransitionActivate,
                [SMUiElementStateMachine]::StateActive
            ),
            [SMTransition]::new(
                [SMUiElementStateMachine]::StateActive,
                [SMUiElementStateMachine]::TransitionDeactivate,
                [SMUiElementStateMachine]::StateInactive
            ),
            [SMTransition]::new(
                [SMUiElementStateMachine]::StateActive,
                [SMUiElementStateMachine]::TransitionFocus,
                [SMUiElementStateMachine]::StateFocused
            ),
            [SMTransition]::new(
                [SMUiElementStateMachine]::StateFocused,
                [SMUiElementStateMachine]::TransitionUnfocus,
                [SMUiElementStateMachine]::StateActive
            ),
            [SMTransition]::new(
                [SMUiElementStateMachine]::StateFocused,
                [SMUiElementStateMachine]::TransitionDeactivate,
                [SMUiElementStateMachine]::StateInactive
            ),
            [SMTransition]::new(
                [SMUiElementStateMachine]::StateInactive,
                [SMUiElementStateMachine]::TransitionDeinit,
                [SMUiElementStateMachine]::StateDeinit
            ),
            [SMTransition]::new(
                [SMUiElementStateMachine]::StateActive,
                [SMUiElementStateMachine]::TransitionDeinit,
                [SMUiElementStateMachine]::StateDeinit
            ),
            [SMTransition]::new(
                [SMUIElementStateMachine]::StateFocused,
                [SMUiElementStateMachine]::TransitionDeinit,
                [SMUiElementStateMachine]::StateDeinit
            ),
            [SMTransition]::new(
                [SMUiElementStateMachine]::StateInit,
                [SMUiElementStateMachine]::TransitionDeinit,
                [SMUiElementStateMachine]::StateDeinit
            )
        ))
    }
}
