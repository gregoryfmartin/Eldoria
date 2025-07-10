using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBATTLEWORNGAUNTLETS
#
###############################################################################

Class BEBattlewornGauntlets : BEGauntlets {
	BEBattlewornGauntlets() : base() {
		$this.Name               = 'Battleworn Gauntlets'
		$this.MapObjName         = 'battleworngauntlets'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::Defense = 32
			[StatId]::MagicDefense = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets that have seen countless battles, scarred but strong.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
