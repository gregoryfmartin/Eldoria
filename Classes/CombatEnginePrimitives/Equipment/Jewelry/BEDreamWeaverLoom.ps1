using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDREAMWEAVERLOOM
#
###############################################################################

Class BEDreamWeaverLoom : BEJewelry {
	BEDreamWeaverLoom() : base() {
		$this.Name               = 'Dream Weaver Loom'
		$this.MapObjName         = 'dreamweaverloom'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 2
			[StatId]::MagicDefense = 2
			[StatId]::Luck = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A tiny loom that subtly influences dreams.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Luck]) LCK"
		$this.TargetGender       = [Gender]::Female
	}
}
