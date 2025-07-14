using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEANCIENTGREAVES
#
###############################################################################

Class BEAncientGreaves : BEGreaves {
	BEAncientGreaves() : base() {
		$this.Name               = 'Ancient Greaves'
		$this.MapObjName         = 'ancientgreaves'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::Defense = 58
			[StatId]::MagicDefense = 38
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves from a forgotten civilization.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
