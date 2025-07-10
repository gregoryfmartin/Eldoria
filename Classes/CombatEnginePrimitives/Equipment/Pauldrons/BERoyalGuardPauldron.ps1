using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEROYALGUARDPAULDRON
#
###############################################################################

Class BERoyalGuardPauldron : BEPauldron {
	BERoyalGuardPauldron() : base() {
		$this.Name               = 'Royal Guard Pauldron'
		$this.MapObjName         = 'royalguardpauldron'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Issued to the elite protectors of the monarchy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
