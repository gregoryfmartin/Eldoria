using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEENCHANTERSPAULDRON
#
###############################################################################

Class BEEnchantersPauldron : BEPauldron {
	BEEnchantersPauldron() : base() {
		$this.Name               = 'Enchanter''s Pauldron'
		$this.MapObjName         = 'enchanterspauldron'
		$this.PurchasePrice      = 1350
		$this.SellPrice          = 675
		$this.TargetStats        = @{
			[StatId]::Defense = 27
			[StatId]::MagicDefense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Enhances enchantments and magical effects.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
