using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWARRIORBOOTS
#
###############################################################################

Class BEWarriorBoots : BEBoots {
	BEWarriorBoots() : base() {
		$this.Name               = 'Warrior Boots'
		$this.MapObjName         = 'warriorboots'
		$this.PurchasePrice      = 380
		$this.SellPrice          = 190
		$this.TargetStats        = @{
			[StatId]::Defense = 20
			[StatId]::MagicDefense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Standard issue boots for a seasoned warrior.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
