using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBLOODBOUNDGAUNTLETS
#
###############################################################################

Class BEBloodboundGauntlets : BEGauntlets {
	BEBloodboundGauntlets() : base() {
		$this.Name               = 'Bloodbound Gauntlets'
		$this.MapObjName         = 'bloodboundgauntlets'
		$this.PurchasePrice      = 1250
		$this.SellPrice          = 625
		$this.TargetStats        = @{
			[StatId]::Defense = 58
			[StatId]::MagicDefense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets that empower the wearer with every wound taken.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
