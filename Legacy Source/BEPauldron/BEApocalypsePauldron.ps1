using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEAPOCALYPSEPAULDRON
#
###############################################################################

Class BEApocalypsePauldron : BEPauldron {
	BEApocalypsePauldron() : base() {
		$this.Name               = 'Apocalypse Pauldron'
		$this.MapObjName         = 'apocalypsepauldron'
		$this.PurchasePrice      = 6800
		$this.SellPrice          = 3400
		$this.TargetStats        = @{
			[StatId]::Defense = 136
			[StatId]::MagicDefense = 57
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Worn during the end of times, immense destructive resistance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
