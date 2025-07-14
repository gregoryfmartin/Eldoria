using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECRYSTALLINEBOOTS
#
###############################################################################

Class BECrystallineBoots : BEBoots {
	BECrystallineBoots() : base() {
		$this.Name               = 'Crystalline Boots'
		$this.MapObjName         = 'crystallineboots'
		$this.PurchasePrice      = 920
		$this.SellPrice          = 460
		$this.TargetStats        = @{
			[StatId]::Defense = 35
			[StatId]::MagicDefense = 27
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots crafted from durable crystals.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
