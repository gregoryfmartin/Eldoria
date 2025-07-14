using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBANSHEEBOOTS
#
###############################################################################

Class BEBansheeBoots : BEBoots {
	BEBansheeBoots() : base() {
		$this.Name               = 'Banshee Boots'
		$this.MapObjName         = 'bansheeboots'
		$this.PurchasePrice      = 750
		$this.SellPrice          = 375
		$this.TargetStats        = @{
			[StatId]::Defense = 22
			[StatId]::MagicDefense = 27
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots that emit a mournful wail.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
