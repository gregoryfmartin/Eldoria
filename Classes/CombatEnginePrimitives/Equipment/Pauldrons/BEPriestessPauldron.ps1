using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPRIESTESSPAULDRON
#
###############################################################################

Class BEPriestessPauldron : BEPauldron {
	BEPriestessPauldron() : base() {
		$this.Name               = 'Priestess Pauldron'
		$this.MapObjName         = 'priestesspauldron'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 22
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Worn by holy priestesses, offering both defense and spiritual aid.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
