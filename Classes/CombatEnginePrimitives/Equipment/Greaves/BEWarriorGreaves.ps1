using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWARRIORGREAVES
#
###############################################################################

Class BEWarriorGreaves : BEGreaves {
	BEWarriorGreaves() : base() {
		$this.Name               = 'Warrior Greaves'
		$this.MapObjName         = 'warriorgreaves'
		$this.PurchasePrice      = 400
		$this.SellPrice          = 200
		$this.TargetStats        = @{
			[StatId]::Defense = 22
			[StatId]::MagicDefense = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Standard issue greaves for a seasoned warrior.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
