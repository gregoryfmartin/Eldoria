using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBLOODSTONEHELM
#
###############################################################################

Class BEBloodstoneHelm : BEHelmet {
	BEBloodstoneHelm() : base() {
		$this.Name               = 'Bloodstone Helm'
		$this.MapObjName         = 'bloodstonehelm'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::Defense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A grim helm with bloodstone, enhancing offensive capabilities at a cost to health.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
