using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEEMPRESSBOOTS
#
###############################################################################

Class BEEmpressBoots : BEBoots {
	BEEmpressBoots() : base() {
		$this.Name               = 'Empress Boots'
		$this.MapObjName         = 'empressboots'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::Defense = 53
			[StatId]::MagicDefense = 33
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of a powerful female ruler.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
