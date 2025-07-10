using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESEERBOOTS
#
###############################################################################

Class BESeerBoots : BEBoots {
	BESeerBoots() : base() {
		$this.Name               = 'Seer Boots'
		$this.MapObjName         = 'seerboots'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{
			[StatId]::Defense = 16
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots that reveal hidden truths.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
