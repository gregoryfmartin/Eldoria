using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BELICHGREAVES
#
###############################################################################

Class BELichGreaves : BEGreaves {
	BELichGreaves() : base() {
		$this.Name               = 'Lich Greaves'
		$this.MapObjName         = 'lichgreaves'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Defense = 40
			[StatId]::MagicDefense = 55
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves of an undead sorcerer.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
