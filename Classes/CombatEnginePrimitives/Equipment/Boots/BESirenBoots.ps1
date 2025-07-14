using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESIRENBOOTS
#
###############################################################################

Class BESirenBoots : BEBoots {
	BESirenBoots() : base() {
		$this.Name               = 'Siren Boots'
		$this.MapObjName         = 'sirenboots'
		$this.PurchasePrice      = 650
		$this.SellPrice          = 325
		$this.TargetStats        = @{
			[StatId]::Defense = 18
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots that lure sailors to their doom.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
