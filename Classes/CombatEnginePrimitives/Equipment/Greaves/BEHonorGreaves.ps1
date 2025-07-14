using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEHONORGREAVES
#
###############################################################################

Class BEHonorGreaves : BEGreaves {
	BEHonorGreaves() : base() {
		$this.Name               = 'Honor Greaves'
		$this.MapObjName         = 'honorgreaves'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 45
			[StatId]::MagicDefense = 22
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves symbolizing integrity.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
