using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEQUEENOFTHORNSROBE
#
###############################################################################

Class BEQueenofThornsRobe : BEArmor {
	BEQueenofThornsRobe() : base() {
		$this.Name               = 'Queen of Thorns Robe'
		$this.MapObjName         = 'queenofthornsrobe'
		$this.PurchasePrice      = 1450
		$this.SellPrice          = 725
		$this.TargetStats        = @{
			[StatId]::Defense = 2
			[StatId]::MagicDefense = 31
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dark, thorny robe, providing protection and minor offensive capabilities.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
