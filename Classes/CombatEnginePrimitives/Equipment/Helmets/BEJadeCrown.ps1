using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEJADECROWN
#
###############################################################################

Class BEJadeCrown : BEHelmet {
	BEJadeCrown() : base() {
		$this.Name               = 'Jade Crown'
		$this.MapObjName         = 'jadecrown'
		$this.PurchasePrice      = 1900
		$this.SellPrice          = 950
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A crown made of pure jade, enhancing wisdom and longevity.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
