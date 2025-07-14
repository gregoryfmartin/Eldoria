using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEHEAVYIRONGAUNTLETS
#
###############################################################################

Class BEHeavyIronGauntlets : BEGauntlets {
	BEHeavyIronGauntlets() : base() {
		$this.Name               = 'Heavy Iron Gauntlets'
		$this.MapObjName         = 'heavyirongauntlets'
		$this.PurchasePrice      = 400
		$this.SellPrice          = 200
		$this.TargetStats        = @{
			[StatId]::Defense = 20
			[StatId]::MagicDefense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Very thick iron gauntlets, slow but incredibly tough.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
