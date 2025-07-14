using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEINQUISITORPAULDRON
#
###############################################################################

Class BEInquisitorPauldron : BEPauldron {
	BEInquisitorPauldron() : base() {
		$this.Name               = 'Inquisitor Pauldron'
		$this.MapObjName         = 'inquisitorpauldron'
		$this.PurchasePrice      = 7250
		$this.SellPrice          = 3625
		$this.TargetStats        = @{
			[StatId]::Defense = 145
			[StatId]::MagicDefense = 66
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Worn by those who seek out and destroy evil, often associated with divine power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
