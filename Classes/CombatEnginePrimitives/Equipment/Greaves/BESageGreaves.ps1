using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESAGEGREAVES
#
###############################################################################

Class BESageGreaves : BEGreaves {
	BESageGreaves() : base() {
		$this.Name               = 'Sage Greaves'
		$this.MapObjName         = 'sagegreaves'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::Defense = 28
			[StatId]::MagicDefense = 40
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves of profound wisdom.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
