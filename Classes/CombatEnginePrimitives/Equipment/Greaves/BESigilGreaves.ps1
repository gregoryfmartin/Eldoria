using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESIGILGREAVES
#
###############################################################################

Class BESigilGreaves : BEGreaves {
	BESigilGreaves() : base() {
		$this.Name               = 'Sigil Greaves'
		$this.MapObjName         = 'sigilgreaves'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 40
			[StatId]::MagicDefense = 32
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves bearing potent magical sigils.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
