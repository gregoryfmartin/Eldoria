using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BERIGHTEOUSGREAVES
#
###############################################################################

Class BERighteousGreaves : BEGreaves {
	BERighteousGreaves() : base() {
		$this.Name               = 'Righteous Greaves'
		$this.MapObjName         = 'righteousgreaves'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{
			[StatId]::Defense = 38
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves of moral rectitude.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
