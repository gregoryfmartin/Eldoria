using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEEMISSARYBOOTS
#
###############################################################################

Class BEEmissaryBoots : BEBoots {
	BEEmissaryBoots() : base() {
		$this.Name               = 'Emissary Boots'
		$this.MapObjName         = 'emissaryboots'
		$this.PurchasePrice      = 350
		$this.SellPrice          = 175
		$this.TargetStats        = @{
			[StatId]::Defense = 12
			[StatId]::MagicDefense = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for special representatives.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
