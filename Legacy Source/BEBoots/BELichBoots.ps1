using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BELICHBOOTS
#
###############################################################################

Class BELichBoots : BEBoots {
	BELichBoots() : base() {
		$this.Name               = 'Lich Boots'
		$this.MapObjName         = 'lichboots'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::Defense = 37
			[StatId]::MagicDefense = 50
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of an undead sorcerer.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
