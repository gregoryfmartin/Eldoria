using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEEXECUTIONERBOOTS
#
###############################################################################

Class BEExecutionerBoots : BEBoots {
	BEExecutionerBoots() : base() {
		$this.Name               = 'Executioner Boots'
		$this.MapObjName         = 'executionerboots'
		$this.PurchasePrice      = 750
		$this.SellPrice          = 375
		$this.TargetStats        = @{
			[StatId]::Defense = 32
			[StatId]::MagicDefense = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Heavy boots for those who carry out sentences.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
