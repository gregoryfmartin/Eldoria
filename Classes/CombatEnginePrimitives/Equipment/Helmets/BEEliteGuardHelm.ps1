using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE ELITE GUARD HELM
#
###############################################################################

Class BEEliteGuardHelm : BEHelmet {
	BEEliteGuardHelm() : base() {
		$this.Name               = 'Elite Guard Helm'
		$this.MapObjName         = 'eliteguardhelm'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Defense = 16
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A polished helm worn by elite guards, offering superior defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
