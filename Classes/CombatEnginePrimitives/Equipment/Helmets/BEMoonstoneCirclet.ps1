using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE MOONSTONE CIRCLET
#
###############################################################################

Class BEMoonstoneCirclet : BEHelmet {
	BEMoonstoneCirclet() : base() {
		$this.Name               = 'Moonstone Circlet'
		$this.MapObjName         = 'moonstonecirclet'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A circlet with moonstone, granting enhanced intuition and nocturnal magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
