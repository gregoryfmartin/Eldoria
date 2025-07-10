using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BELIONHEARTVAMBRACES
#
###############################################################################

Class BELionheartVambraces : BEGauntlets {
	BELionheartVambraces() : base() {
		$this.Name               = 'Lionheart Vambraces'
		$this.MapObjName         = 'lionheartvambraces'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::Defense = 72
			[StatId]::MagicDefense = 28
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Vambraces bearing the crest of a lion, inspiring courage.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
