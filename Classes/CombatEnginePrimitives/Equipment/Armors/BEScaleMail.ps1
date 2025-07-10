using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESCALEMAIL
#
###############################################################################

Class BEScaleMail : BEArmor {
	BEScaleMail() : base() {
		$this.Name               = 'Scale Mail'
		$this.MapObjName         = 'scalemail'
		$this.PurchasePrice      = 400
		$this.SellPrice          = 200
		$this.TargetStats        = @{
			[StatId]::Defense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Armor made from overlapping scales of metal or hardened leather.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
