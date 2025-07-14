using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEIRONBOUNDGAUNTLETS
#
###############################################################################

Class BEIronboundGauntlets : BEGauntlets {
	BEIronboundGauntlets() : base() {
		$this.Name               = 'Ironbound Gauntlets'
		$this.MapObjName         = 'ironboundgauntlets'
		$this.PurchasePrice      = 350
		$this.SellPrice          = 175
		$this.TargetStats        = @{
			[StatId]::Defense = 17
			[StatId]::MagicDefense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets tightly bound with iron strips, very durable.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
