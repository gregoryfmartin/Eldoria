using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEZOMBIEBOOTS
#
###############################################################################

Class BEZombieBoots : BEBoots {
	BEZombieBoots() : base() {
		$this.Name               = 'Zombie Boots'
		$this.MapObjName         = 'zombieboots'
		$this.PurchasePrice      = 40
		$this.SellPrice          = 20
		$this.TargetStats        = @{
			[StatId]::Defense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Rotting boots, barely functional.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
