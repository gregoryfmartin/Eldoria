using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWINDTUNIC
#
###############################################################################

Class BEWindTunic : BEArmor {
	BEWindTunic() : base() {
		$this.Name               = 'Wind Tunic'
		$this.MapObjName         = 'windtunic'
		$this.PurchasePrice      = 180
		$this.SellPrice          = 90
		$this.TargetStats        = @{
			[StatId]::Defense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A light tunic that makes the wearer feel swifter.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
