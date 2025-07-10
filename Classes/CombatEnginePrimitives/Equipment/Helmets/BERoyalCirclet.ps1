using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEROYALCIRCLET
#
###############################################################################

Class BERoyalCirclet : BEHelmet {
	BERoyalCirclet() : base() {
		$this.Name               = 'Royal Circlet'
		$this.MapObjName         = 'royalcirclet'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An elegant circlet adorned with jewels, worn by royalty.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
