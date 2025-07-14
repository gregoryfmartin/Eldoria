using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBRUTEPAULDRON
#
###############################################################################

Class BEBrutePauldron : BEPauldron {
	BEBrutePauldron() : base() {
		$this.Name               = 'Brute Pauldron'
		$this.MapObjName         = 'brutepauldron'
		$this.PurchasePrice      = 8350
		$this.SellPrice          = 4175
		$this.TargetStats        = @{
			[StatId]::Defense = 167
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Heavy and unforgiving, for overwhelming opponents with raw strength.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
