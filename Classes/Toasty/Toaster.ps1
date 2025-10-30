using namespace System
using namespace System.Collections.Generic

Set-StrictMode -Version Latest

###############################################################################
#
# TOASTER
#
# LET'S MAKE SOME MOFO TOAST!
#
# IDEA #1 - LET'S SHOW A TOAST WITH A PROGRESS BAR THAT BEHAVES AS A SURROGATE
# HEALTH BAR FOR THE PLAYER AND ENEMY ENTITY DURING A BATTLE SEQUENCE.
#
###############################################################################

Class Toaster {
    [List[Toast]]$Loaf
    
    Toaster() {
        $this.Loaf = [List[Toast]]::new()
    }
    
    Toaster(
        [Toast[]]$NewLoaf
    ) {
        $this.Loaf = [List[Toast]]::new()
        
        If($NewLoaf) {
            Foreach($Bread in $NewLoaf) {
                $this.Loaf.Add($Bread)
            }
        }
    }
    
    [Void]BurnAPieceOfToast(
        [String]$SliceId
    ) {
        Foreach($Slice in $this.Loaf) {
            If($Slice.Id -EQ $SliceId) {
                $Slice.CreateToast()
            }
        }
    }
    
    [Void]BurnSomeToast(
        [String[]]$SliceIds
    ) {
        Foreach($Id in $SliceIds) {
            $this.BurnAPieceOfToast($Id)
        }
    }
    
    [Void]ButterAPieceOfToast(
        [String]$SliceId,
        [Hashtable]$Binder
    ) {
        Foreach($Slice in $this.Loaf) {
            If($Slice.Id -EQ $SliceId -AND $Binder) {
                If($Binder) {
                    If($Binder.ContainsKey('PlayerBarValue')) {
                        $Binder['PlayerBarValue'] = $this.NormalizeBarValue(
                            $Script:ThePlayer.Stats[[StatId]::HitPoints].Base,
                            0,
                            $Script:ThePlayer.Stats[[StatId]::HitPoints].Max
                        )
                    }
                    If($Binder.ContainsKey('EnemyBarValue')) {
                        $Binder['EnemyBarValue'] = $this.NormalizeBarValue(
                            $Script:TheCurrentEnemy.Stats[[StatId]::HitPoints].Base,
                            0,
                            $Script:TheCurrentEnemy.Stats[[StatId]::HitPoints].Max
                        )
                    }
                }
                $Slice.Bindable = $Binder
                $Slice.Butter()
            }
        }
    }
    
    [Float]NormalizeBarValue(
        [Int]$Value,
        [Int]$Min,
        [Int]$Max
    ) {
        Return ($Value - $Min) / ($Max - $Min)
    }
}
