using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDEATHGIVERSHELM
#
###############################################################################

Class BEDeathGiversHelm : BEHelmet {
	BEDeathGiversHelm() : base() {
		$this.Name               = 'Death Giver''s Helm'
		$this.MapObjName         = 'deathgivershelm'
		$this.PurchasePrice      = 11500
		$this.SellPrice          = 5750
		$this.TargetStats        = @{
			[StatId]::Defense = 98
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm that radiates death energy, bringing ruin to enemies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
