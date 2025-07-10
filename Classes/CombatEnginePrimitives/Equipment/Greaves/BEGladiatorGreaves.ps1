using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGLADIATORGREAVES
#
###############################################################################

Class BEGladiatorGreaves : BEGreaves {
	BEGladiatorGreaves() : base() {
		$this.Name               = 'Gladiator Greaves'
		$this.MapObjName         = 'gladiatorgreaves'
		$this.PurchasePrice      = 680
		$this.SellPrice          = 340
		$this.TargetStats        = @{
			[StatId]::Defense = 36
			[StatId]::MagicDefense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Heavy greaves worn by arena champions.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
