using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEVALORBOOTS
#
###############################################################################

Class BEValorBoots : BEBoots {
	BEValorBoots() : base() {
		$this.Name               = 'Valor Boots'
		$this.MapObjName         = 'valorboots'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Defense = 50
			[StatId]::MagicDefense = 29
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots embodying courage and bravery.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
