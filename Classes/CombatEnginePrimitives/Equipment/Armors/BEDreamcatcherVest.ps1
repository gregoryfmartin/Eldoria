using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDREAMCATCHERVEST
#
###############################################################################

Class BEDreamcatcherVest : BEArmor {
	BEDreamcatcherVest() : base() {
		$this.Name               = 'Dreamcatcher Vest'
		$this.MapObjName         = 'dreamcatchervest'
		$this.PurchasePrice      = 380
		$this.SellPrice          = 190
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vest woven with mystical strands, protecting against magical sleep.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
