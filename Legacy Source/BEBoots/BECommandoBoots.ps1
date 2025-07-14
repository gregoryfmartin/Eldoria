using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECOMMANDOBOOTS
#
###############################################################################

Class BECommandoBoots : BEBoots {
	BECommandoBoots() : base() {
		$this.Name               = 'Commando Boots'
		$this.MapObjName         = 'commandoboots'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::Defense = 37
			[StatId]::MagicDefense = 13
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for elite fighting units.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
