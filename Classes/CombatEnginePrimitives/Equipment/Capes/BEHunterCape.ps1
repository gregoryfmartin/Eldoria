using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEHUNTERCAPE
#
###############################################################################

Class BEHunterCape : BECape {
	BEHunterCape() : base() {
		$this.Name               = 'Hunter Cape'
		$this.MapObjName         = 'huntercape'
		$this.PurchasePrice      = 250
		$this.SellPrice          = 125
		$this.TargetStats        = @{
			[StatId]::Speed = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A practical cape favored by trackers and hunters.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}
