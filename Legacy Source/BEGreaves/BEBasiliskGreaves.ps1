using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBASILISKGREAVES
#
###############################################################################

Class BEBasiliskGreaves : BEGreaves {
	BEBasiliskGreaves() : base() {
		$this.Name               = 'Basilisk Greaves'
		$this.MapObjName         = 'basiliskgreaves'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 40
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves made from basilisk hide, resistant to petrification.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
