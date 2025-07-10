using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESPIRITBOUNDGAUNTLETSII
#
###############################################################################

Class BESpiritboundGauntletsII : BEGauntlets {
	BESpiritboundGauntletsII() : base() {
		$this.Name               = 'Spiritbound Gauntlets II'
		$this.MapObjName         = 'spiritboundgauntletsii'
		$this.PurchasePrice      = 1050
		$this.SellPrice          = 525
		$this.TargetStats        = @{
			[StatId]::Defense = 30
			[StatId]::MagicDefense = 38
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'More potent Spiritbound Gauntlets, stronger link to spirits.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
