using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPIONEERSHAT
#
###############################################################################

Class BEPioneersHat : BEHelmet {
	BEPioneersHat() : base() {
		$this.Name               = 'Pioneer''s Hat'
		$this.MapObjName         = 'pioneershat'
		$this.PurchasePrice      = 120
		$this.SellPrice          = 60
		$this.TargetStats        = @{
			[StatId]::Defense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sturdy hat for pioneers, essential for exploration.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
