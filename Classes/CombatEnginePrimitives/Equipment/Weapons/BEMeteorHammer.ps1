using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE METEOR HAMMER
#
###############################################################################

Class BEMeteorHammer : BEWeapon {
	BEMeteorHammer() : base() {
		$this.Name          = 'Meteor Hammer'
		$this.MapObjName    = 'meteorhammer'
		$this.PurchasePrice = 880
		$this.SellPrice     = 440
		$this.TargetStats   = @{
			[StatId]::Attack = 52
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A heavy ball and chain, strikes with incredible force.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
