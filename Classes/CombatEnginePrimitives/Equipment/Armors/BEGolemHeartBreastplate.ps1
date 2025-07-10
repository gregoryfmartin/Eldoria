using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGOLEMHEARTBREASTPLATE
#
###############################################################################

Class BEGolemHeartBreastplate : BEArmor {
	BEGolemHeartBreastplate() : base() {
		$this.Name               = 'Golem Heart Breastplate'
		$this.MapObjName         = 'golemheartbreastplate'
		$this.PurchasePrice      = 2300
		$this.SellPrice          = 1150
		$this.TargetStats        = @{
			[StatId]::Defense = 33
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A breastplate embedded with the pulsating core of a golem.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
