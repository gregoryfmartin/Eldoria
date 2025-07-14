using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEVALORGREAVES
#
###############################################################################

Class BEValorGreaves : BEGreaves {
	BEValorGreaves() : base() {
		$this.Name               = 'Valor Greaves'
		$this.MapObjName         = 'valorgreaves'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::Defense = 55
			[StatId]::MagicDefense = 32
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves embodying courage and bravery.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
