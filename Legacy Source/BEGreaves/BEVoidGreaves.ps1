using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEVOIDGREAVES
#
###############################################################################

Class BEVoidGreaves : BEGreaves {
	BEVoidGreaves() : base() {
		$this.Name               = 'Void Greaves'
		$this.MapObjName         = 'voidgreaves'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{
			[StatId]::Defense = 70
			[StatId]::MagicDefense = 50
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves that draw power from the void.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
