using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEANCIENTSTEELGAUNTLETSIII
#
###############################################################################

Class BEAncientSteelGauntletsIII : BEGauntlets {
	BEAncientSteelGauntletsIII() : base() {
		$this.Name               = 'Ancient Steel Gauntlets III'
		$this.MapObjName         = 'ancientsteelgauntletsiii'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::Defense = 55
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Ancient Steel Gauntlets of ultimate durability, unyielding.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
