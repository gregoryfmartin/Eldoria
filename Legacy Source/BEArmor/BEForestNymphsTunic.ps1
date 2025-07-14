using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEFORESTNYMPHSTUNIC
#
###############################################################################

Class BEForestNymphsTunic : BEArmor {
	BEForestNymphsTunic() : base() {
		$this.Name               = 'Forest Nymph''s Tunic'
		$this.MapObjName         = 'forestnymphstunic'
		$this.PurchasePrice      = 150
		$this.SellPrice          = 75
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A tunic made from living leaves and moss, blending with nature.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
