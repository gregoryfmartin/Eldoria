using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BENEBULABOOTS
#
###############################################################################

Class BENebulaBoots : BEBoots {
	BENebulaBoots() : base() {
		$this.Name               = 'Nebula Boots'
		$this.MapObjName         = 'nebulaboots'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::Defense = 55
			[StatId]::MagicDefense = 50
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots shimmering with cosmic dust.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
