using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE AIR ELEMENTAL CORE HELM

#
###############################################################################

Class BEAirElementalCoreHelm : BEHelmet {
	BEAirElementalCoreHelm() : base() {
		$this.Name               = 'Air Elemental Core Helm'
		$this.MapObjName         = 'airelementalcorehelm'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm infused with an air elemental core, granting enhanced agility.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
