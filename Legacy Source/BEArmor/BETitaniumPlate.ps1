using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BETITANIUMPLATE
#
###############################################################################

Class BETitaniumPlate : BEArmor {
	BETitaniumPlate() : base() {
		$this.Name               = 'Titanium Plate'
		$this.MapObjName         = 'titaniumplate'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{
			[StatId]::Defense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Lightweight yet incredibly strong plate armor.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
