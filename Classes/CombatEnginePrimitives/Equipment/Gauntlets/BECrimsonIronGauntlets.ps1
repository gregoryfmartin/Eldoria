using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECRIMSONIRONGAUNTLETS
#
###############################################################################

Class BECrimsonIronGauntlets : BEGauntlets {
	BECrimsonIronGauntlets() : base() {
		$this.Name               = 'Crimson Iron Gauntlets'
		$this.MapObjName         = 'crimsonirongauntlets'
		$this.PurchasePrice      = 200
		$this.SellPrice          = 100
		$this.TargetStats        = @{
			[StatId]::Defense = 11
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Iron gauntlets dyed crimson, symbolizing ferocity.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
