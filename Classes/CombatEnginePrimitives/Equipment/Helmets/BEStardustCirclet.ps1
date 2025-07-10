using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESTARDUSTCIRCLET
#
###############################################################################

Class BEStardustCirclet : BEHelmet {
	BEStardustCirclet() : base() {
		$this.Name               = 'Stardust Circlet'
		$this.MapObjName         = 'stardustcirclet'
		$this.PurchasePrice      = 3500
		$this.SellPrice          = 1750
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 28
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A circlet crafted from condensed stardust, granting cosmic awareness.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
