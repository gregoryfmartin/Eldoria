using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBEARCAPE
#
###############################################################################

Class BEBearCape : BECape {
    BEBearCape() : base() {
		$this.Name               = 'Bear Cape'
		$this.MapObjName         = 'bearcape'
		$this.PurchasePrice      = 0
		$this.SellPrice          = 0
		$this.TargetStats        = @{
            [StatId]::Luck = 999
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'The ultimate in fuzzy capes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Luck]) LCK"
		$this.TargetGender       = [Gender]::Unisex
    }
}
