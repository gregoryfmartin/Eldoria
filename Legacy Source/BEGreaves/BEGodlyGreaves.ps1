using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGODLYGREAVES
#
###############################################################################

Class BEGodlyGreaves : BEGreaves {
	BEGodlyGreaves() : base() {
		$this.Name               = 'Godly Greaves'
		$this.MapObjName         = 'godlygreaves'
		$this.PurchasePrice      = 2500
		$this.SellPrice          = 1250
		$this.TargetStats        = @{
			[StatId]::Defense = 90
			[StatId]::MagicDefense = 60
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves worn by deities, immense power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
