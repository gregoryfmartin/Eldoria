using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESUNSTONEGREAVES
#
###############################################################################

Class BESunstoneGreaves : BEGreaves {
	BESunstoneGreaves() : base() {
		$this.Name               = 'Sunstone Greaves'
		$this.MapObjName         = 'sunstonegreaves'
		$this.PurchasePrice      = 1350
		$this.SellPrice          = 675
		$this.TargetStats        = @{
			[StatId]::Defense = 52
			[StatId]::MagicDefense = 32
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves that shimmer with solar energy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
