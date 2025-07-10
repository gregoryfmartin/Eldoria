using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEVIRTUEGREAVES
#
###############################################################################

Class BEVirtueGreaves : BEGreaves {
	BEVirtueGreaves() : base() {
		$this.Name               = 'Virtue Greaves'
		$this.MapObjName         = 'virtuegreaves'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::Defense = 35
			[StatId]::MagicDefense = 16
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves representing moral excellence.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
