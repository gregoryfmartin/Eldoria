using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BERAGGEDSHIRT
#
###############################################################################

Class BERaggedShirt : BEArmor {
	BERaggedShirt() : base() {
		$this.Name               = 'Ragged Shirt'
		$this.MapObjName         = 'raggedshirt'
		$this.PurchasePrice      = 20
		$this.SellPrice          = 10
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A tattered shirt, barely offering any protection.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}
