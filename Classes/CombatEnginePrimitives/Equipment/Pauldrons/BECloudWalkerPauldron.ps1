using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECLOUDWALKERPAULDRON
#
###############################################################################

Class BECloudWalkerPauldron : BEPauldron {
	BECloudWalkerPauldron() : base() {
		$this.Name               = 'Cloud Walker Pauldron'
		$this.MapObjName         = 'cloudwalkerpauldron'
		$this.PurchasePrice      = 2850
		$this.SellPrice          = 1425
		$this.TargetStats        = @{
			[StatId]::Defense = 57
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Allows for graceful movement across aerial platforms.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
