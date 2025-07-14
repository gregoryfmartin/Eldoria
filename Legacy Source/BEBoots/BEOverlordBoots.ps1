using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEOVERLORDBOOTS
#
###############################################################################

Class BEOverlordBoots : BEBoots {
	BEOverlordBoots() : base() {
		$this.Name               = 'Overlord Boots'
		$this.MapObjName         = 'overlordboots'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::Defense = 50
			[StatId]::MagicDefense = 27
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of a supreme master.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
