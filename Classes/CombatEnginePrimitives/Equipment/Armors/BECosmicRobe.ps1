using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECOSMICROBE
#
###############################################################################

Class BECosmicRobe : BEArmor {
	BECosmicRobe() : base() {
		$this.Name               = 'Cosmic Robe'
		$this.MapObjName         = 'cosmicrobe'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 40
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe depicting constellations, allowing glimpses of future spells.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
