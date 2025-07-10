using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECLOUDSPUNTHREAD
#
###############################################################################

Class BECloudspunThread : BEJewelry {
	BECloudspunThread() : base() {
		$this.Name               = 'Cloudspun Thread'
		$this.MapObjName         = 'cloudspunthread'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::Speed = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A strand of thread woven from clouds, incredibly light.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}
