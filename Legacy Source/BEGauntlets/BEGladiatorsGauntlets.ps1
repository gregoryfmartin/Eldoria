using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGLADIATORSGAUNTLETS
#
###############################################################################

Class BEGladiatorsGauntlets : BEGauntlets {
	BEGladiatorsGauntlets() : base() {
		$this.Name               = 'Gladiator''s Gauntlets'
		$this.MapObjName         = 'gladiatorsgauntlets'
		$this.PurchasePrice      = 370
		$this.SellPrice          = 185
		$this.TargetStats        = @{
			[StatId]::Defense = 19
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Rough yet effective gauntlets for arena combat.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
