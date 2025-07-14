using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BERUNICBREASTPLATE
#
###############################################################################

Class BERunicBreastplate : BEArmor {
	BERunicBreastplate() : base() {
		$this.Name               = 'Runic Breastplate'
		$this.MapObjName         = 'runicbreastplate'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::Defense = 25
			[StatId]::MagicDefense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A breastplate etched with protective runes, offering strong magical defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
