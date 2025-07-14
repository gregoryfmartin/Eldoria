using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESCOUTSHAT
#
###############################################################################

Class BEScoutsHat : BEHelmet {
	BEScoutsHat() : base() {
		$this.Name               = 'Scout''s Hat'
		$this.MapObjName         = 'scoutshat'
		$this.PurchasePrice      = 60
		$this.SellPrice          = 30
		$this.TargetStats        = @{
			[StatId]::Defense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A lightweight hat for scouts, providing good visibility and protection from elements.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
