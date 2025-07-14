using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BENETHERROBE
#
###############################################################################

Class BENetherRobe : BEArmor {
	BENetherRobe() : base() {
		$this.Name               = 'Nether Robe'
		$this.MapObjName         = 'netherrobe'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 29
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dark robe from the underworld, radiating ominous energy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
