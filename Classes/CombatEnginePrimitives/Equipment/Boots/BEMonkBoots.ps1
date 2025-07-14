using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMONKBOOTS
#
###############################################################################

Class BEMonkBoots : BEBoots {
	BEMonkBoots() : base() {
		$this.Name               = 'Monk Boots'
		$this.MapObjName         = 'monkboots'
		$this.PurchasePrice      = 330
		$this.SellPrice          = 165
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 14
			[StatId]::Speed = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Light boots for martial arts practitioners.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}
