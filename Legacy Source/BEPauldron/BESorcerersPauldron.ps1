using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESORCERERSPAULDRON
#
###############################################################################

Class BESorcerersPauldron : BEPauldron {
	BESorcerersPauldron() : base() {
		$this.Name               = 'Sorcerer''s Pauldron'
		$this.MapObjName         = 'sorcererspauldron'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::Defense = 24
			[StatId]::MagicDefense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Favored by powerful sorcerers, enhancing their spellcasting.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
