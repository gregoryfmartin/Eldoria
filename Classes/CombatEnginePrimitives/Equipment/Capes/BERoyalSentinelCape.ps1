using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEROYALSENTINELCAPE
#
###############################################################################

Class BERoyalSentinelCape : BECape {
	BERoyalSentinelCape() : base() {
		$this.Name               = 'Royal Sentinel Cape'
		$this.MapObjName         = 'royalsentinelcape'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A finely embroidered cape, worn by the elite royal guard.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Male
	}
}
