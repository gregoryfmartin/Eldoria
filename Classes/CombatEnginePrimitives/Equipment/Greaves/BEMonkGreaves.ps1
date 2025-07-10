using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMONKGREAVES
#
###############################################################################

Class BEMonkGreaves : BEGreaves {
	BEMonkGreaves() : base() {
		$this.Name               = 'Monk Greaves'
		$this.MapObjName         = 'monkgreaves'
		$this.PurchasePrice      = 360
		$this.SellPrice          = 180
		$this.TargetStats        = @{
			[StatId]::Defense = 12
			[StatId]::MagicDefense = 16
			[StatId]::Speed = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Light greaves for martial arts practitioners.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}
