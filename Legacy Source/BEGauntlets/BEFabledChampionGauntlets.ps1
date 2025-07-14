using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEFABLEDCHAMPIONGAUNTLETS
#
###############################################################################

Class BEFabledChampionGauntlets : BEGauntlets {
	BEFabledChampionGauntlets() : base() {
		$this.Name               = 'Fabled Champion Gauntlets'
		$this.MapObjName         = 'fabledchampiongauntlets'
		$this.PurchasePrice      = 2800
		$this.SellPrice          = 1400
		$this.TargetStats        = @{
			[StatId]::Defense = 135
			[StatId]::MagicDefense = 70
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets of a fabled champion, unmatched power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
