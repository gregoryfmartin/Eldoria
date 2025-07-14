using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESHERIFFBOOTS
#
###############################################################################

Class BESheriffBoots : BEBoots {
	BESheriffBoots() : base() {
		$this.Name               = 'Sheriff Boots'
		$this.MapObjName         = 'sheriffboots'
		$this.PurchasePrice      = 370
		$this.SellPrice          = 185
		$this.TargetStats        = @{
			[StatId]::Defense = 16
			[StatId]::MagicDefense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of a law enforcer.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
