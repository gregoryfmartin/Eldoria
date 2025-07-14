using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPRIESTESSSCUFFS
#
###############################################################################

Class BEPriestesssCuffs : BEGauntlets {
	BEPriestesssCuffs() : base() {
		$this.Name               = 'Priestess''s Cuffs'
		$this.MapObjName         = 'priestessscuffs'
		$this.PurchasePrice      = 400
		$this.SellPrice          = 200
		$this.TargetStats        = @{
			[StatId]::Defense = 11
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Cuffs worn by priestesses, aiding in benevolent magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
