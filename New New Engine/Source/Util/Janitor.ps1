using namespace System
using namespace System.Management.Automation

Set-StrictMode -Version Latest





###############################################################################
#
# JANITOR
#
# MAINTAINS ALL THE UGLY PLUMBING SHIT.
#
###############################################################################

Class Janitor {
    [SemanticVersion]$CurrentGameVersion
    [SemanticVersion]$CurrentPSVersion
    [String]$CurrentPSEdition
    [String]$CurrentOS

    Janitor(
        [Hashtable]$PSVersionInfo
    ) {
        $this.CurrentGameVersion = [SemanticVersion]::new(0, 1, 0)
        $this.CurrentPSVersion   = $PSVersionInfo.PSVersion
        $this.CurrentPSEdition   = $PSVersionInfo.PSEdition
        $this.CurrentOS          = $PSVersionInfo.OS
    }

    [Void]PerformSystemSetupChecks(
        [ContextBroadcaster]$ContextBroadcaster
    ) {
        $this.CheckOS($ContextBroadcaster)
        $this.CheckPSEdition($ContextBroadcaster)
        $this.CheckPSVersion($ContextBroadcaster)
    }

    [Void]PerformRegularChecks(
        [ContextBroadcaster]$ContextBroadcaster,
        [BufferSpecDefinition]$Bsd
    ) {
        $this.CheckBufferWidth($ContextBroadcaster, $Bsd)
        $this.CheckBufferHeight($ContextBroadcaster, $Bsd)
    }

    [Void]CheckPSEdition(
        [ContextBroadcaster]$ContextBroadcaster
    ) {
        If($null -EQ $ContextBroadcaster) {
            # CAN'T DO ANYTHING IF THE CONTEXT BROADCASTER IS NULL

            Return
        }

        If($this.CurrentPSEdition -NE 'Core') {
            $ContextBroadcaster.Broadcast(
                [CustomEvents]::BadPSEdition,
                $this,
                @(
                    $this
                )
            )
        }
    }

    [Void]CheckPSVersion(
        [ContextBroadcaster]$ContextBroadcaster
    ) {
        # DO NOTHING AT THIS POINT AS VERSION LOCKING REALLY ISN'T
        # AN IMPORTANT FACTOR

        Return
    }

    [Void]CheckOS(
        [ContextBroadcaster]$ContextBroadcaster
    ) {
        # DO NOTHING AT THIS POINT AS OS LOCKING REALLY ISN'T
        # AN IMPORTANT FACTOR

        Return
    }

    [Void]CheckBufferWidth(
        [ContextBroadcaster]$ContextBroadcaster,
        [BufferSpecDefinition]$Bsd
    ) {
        If($null -EQ $ContextBroadcaster -OR $null -EQ $Bsd) {
            # CAN'T DO ANYTHING IF EITHER OF THESE ARGUMENTS IS NULL
            
            Return
        }

        If([Console]::BufferWidth -LT $Bsd.BufferMinWidth) {
            $ContextBroadcaster.Broadcast(
                [CustomEvents]::BufferWidthTooSmall,
                $this,
                [Context]::new(@(
                    $this,
                    [PSCustomObject]@{
                        UserBufferWidth = [Console]::BufferWidth
                    }
                ))
            )
        }
    }

    [Void]CheckBufferHeight(
        [ContextBroadcaster]$ContextBroadcaster,
        [BufferSpecDefinition]$Bsd
    ) {
        If($null -EQ $ContextBroadcaster -OR $null -EQ $Bsd) {
            # CAN'T DO ANYTHING IF EITHER OF THESE ARGUMENTS IS NULL

            Return
        }

        If([Console]::BufferHeight -LT $Bsd.BufferMinHeight) {
            $ContextBroadcaster.Broadcast(
                [CustomEvents]::BufferHeightTooSmall,
                $this,
                [Context]::new(@(
                    $this,
                    [PSCustomObject]@{
                        UserBufferHeight = [Console]::BufferHeight
                    }
                ))
            )
        }
    }
}
