using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEILLUSIONISTPAULDRON
#
###############################################################################

Class BEIllusionistPauldron : BEPauldron {
	BEIllusionistPauldron() : base() {
		$this.Name               = 'Illusionist Pauldron'
		$this.MapObjName         = 'illusionistpauldron'
		$this.PurchasePrice      = 7750
		$this.SellPrice          = 3875
		$this.TargetStats        = @{
			[StatId]::Defense = 155
			[StatId]::MagicDefense = 76
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Creates convincing illusions and disorients foes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
