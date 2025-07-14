using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEHEROICPAULDRON
#
###############################################################################

Class BEHeroicPauldron : BEPauldron {
	BEHeroicPauldron() : base() {
		$this.Name               = 'Heroic Pauldron'
		$this.MapObjName         = 'heroicpauldron'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::Defense = 14
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A pauldron worn by heroes of old, imbued with fighting spirit.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
