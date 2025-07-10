using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGOTHICPLATE
#
###############################################################################

Class BEGothicPlate : BEArmor {
	BEGothicPlate() : base() {
		$this.Name               = 'Gothic Plate'
		$this.MapObjName         = 'gothicplate'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
			[StatId]::Defense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Dark, imposing plate armor with sharp edges.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
