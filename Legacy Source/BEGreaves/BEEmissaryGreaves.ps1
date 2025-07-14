using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEEMISSARYGREAVES
#
###############################################################################

Class BEEmissaryGreaves : BEGreaves {
	BEEmissaryGreaves() : base() {
		$this.Name               = 'Emissary Greaves'
		$this.MapObjName         = 'emissarygreaves'
		$this.PurchasePrice      = 380
		$this.SellPrice          = 190
		$this.TargetStats        = @{
			[StatId]::Defense = 13
			[StatId]::MagicDefense = 13
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves for special representatives.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
