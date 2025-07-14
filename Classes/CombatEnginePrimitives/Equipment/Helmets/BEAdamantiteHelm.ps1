using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEADAMANTITEHELM
#
###############################################################################

Class BEAdamantiteHelm : BEHelmet {
	BEAdamantiteHelm() : base() {
		$this.Name               = 'Adamantite Helm'
		$this.MapObjName         = 'adamantitehelm'
		$this.PurchasePrice      = 4500
		$this.SellPrice          = 2250
		$this.TargetStats        = @{
			[StatId]::Defense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A supremely strong helm made from adamantite, offering near-invincible defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
