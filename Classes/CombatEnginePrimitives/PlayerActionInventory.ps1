using namespace System
using namespace System.Collections.Generic

Set-StrictMode -Version Latest

###############################################################################
#
# PLAYER ACTION INVENTORY
#
# A FOCAL POINT FOR THE PLAYER'S BATTLE ACTION INVENTORY.
#
###############################################################################

Class PlayerActionInventory {
    [List[BattleAction]]$Listing = [List[BattleAction]]::new()

    [Boolean]IsActionInInventory(
        [String]$ActionName
    ) {
        Foreach($a in $this.Listing) {
            If($a.Name -IEQ $ActionName) {
                Return $true
            }
        }

        Return $false
    }

    [BattleAction]GetActionReference(
        [String]$ActionName
    ) {
        Foreach($a in $this.Listing) {
            If($a.Name -IEQ $ActionName) {
                Return $a
            }
        }

        Return $null
    }

    [ActionInvRemovalStatus]RemoveActionByName(
        [String]$ActionName
    ) {
        [Int]$c = 0

        Foreach($a in $this.Listing) {
            If($a.Name -IEQ $ActionName) {
                $this.Listing.RemoveAt($c)

                Return [ActionInvRemovalStatus]::Success
            }
            $c++
        }

        Return [ActionInvRemovalStatus]::Fail
    }

    [ActionInvRemovalStatus]RemoveActionByIndex(
        [Int]$Index
    ) {
        [BattleAction]$a = $null

        Try {
            $a = $this.Listing[$Index]
        } Catch {
            Return [ActionInvRemovalStatus]::Fail
        }
        $this.Listing.RemoveAt($Index)

        Return [ActionInvRemovalStatus]::Success
    }

    [Boolean]Add(
        [BattleAction]$ActionToAdd
    ) {
        [Boolean]$ActionAlreadyListed = $this.IsActionInInventory($ActionToAdd.Name)

        If($ActionAlreadyListed -EQ $true) {
            Return $false
        }
        $this.Listing.Add($ActionToAdd)

        Return $true
    }
}
