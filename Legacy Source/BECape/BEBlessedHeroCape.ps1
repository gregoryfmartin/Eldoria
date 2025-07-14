using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBLESSEDHEROCAPE
#
###############################################################################

Class BEBlessedHeroCape : BECape {
	BEBlessedHeroCape() : base() {
		$this.Name               = 'Blessed Hero Cape'
		$this.MapObjName         = 'blessedherocape'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::Luck = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A cape worn by a legendary hero, imbued with divine favor.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Luck]) LCK"
		$this.TargetGender       = [Gender]::Male
	}
}
