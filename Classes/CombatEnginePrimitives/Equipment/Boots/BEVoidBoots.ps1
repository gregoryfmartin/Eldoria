using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEVOIDBOOTS
#
###############################################################################

Class BEVoidBoots : BEBoots {
	BEVoidBoots() : base() {
		$this.Name               = 'Void Boots'
		$this.MapObjName         = 'voidboots'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{
			[StatId]::Defense = 65
			[StatId]::MagicDefense = 45
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots that draw power from the void.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
