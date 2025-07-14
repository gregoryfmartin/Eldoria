using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDEMONPAULDRON
#
###############################################################################

Class BEDemonPauldron : BEPauldron {
	BEDemonPauldron() : base() {
		$this.Name               = 'Demon Pauldron'
		$this.MapObjName         = 'demonpauldron'
		$this.PurchasePrice      = 6050
		$this.SellPrice          = 3025
		$this.TargetStats        = @{
			[StatId]::Defense = 121
			[StatId]::MagicDefense = 44
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Forged in the depths of hell, imbued with dark, corrupting power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
