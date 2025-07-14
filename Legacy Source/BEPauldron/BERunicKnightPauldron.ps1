using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BERUNICKNIGHTPAULDRON
#
###############################################################################

Class BERunicKnightPauldron : BEPauldron {
	BERunicKnightPauldron() : base() {
		$this.Name               = 'Runic Knight Pauldron'
		$this.MapObjName         = 'runicknightpauldron'
		$this.PurchasePrice      = 7000
		$this.SellPrice          = 3500
		$this.TargetStats        = @{
			[StatId]::Defense = 140
			[StatId]::MagicDefense = 61
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Covered in ancient runes, granting both physical and magical defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
