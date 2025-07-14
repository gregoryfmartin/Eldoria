using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEINFILTRATORSMASK
#
###############################################################################

Class BEInfiltratorsMask : BEHelmet {
	BEInfiltratorsMask() : base() {
		$this.Name               = 'Infiltrator''s Mask'
		$this.MapObjName         = 'infiltratorsmask'
		$this.PurchasePrice      = 160
		$this.SellPrice          = 80
		$this.TargetStats        = @{
			[StatId]::Defense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dark mask worn by infiltrators, aiding in covert operations.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
