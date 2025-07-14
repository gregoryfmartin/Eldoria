using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECENTAURGREAVES
#
###############################################################################

Class BECentaurGreaves : BEGreaves {
	BECentaurGreaves() : base() {
		$this.Name               = 'Centaur Greaves'
		$this.MapObjName         = 'centaurgreaves'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::Defense = 30
			[StatId]::MagicDefense = 15
			[StatId]::Speed = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves for equestrian warriors.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}
