using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESUNKENPLATE
#
###############################################################################

Class BESunkenPlate : BEArmor {
	BESunkenPlate() : base() {
		$this.Name               = 'Sunken Plate'
		$this.MapObjName         = 'sunkenplate'
		$this.PurchasePrice      = 2200
		$this.SellPrice          = 1100
		$this.TargetStats        = @{
			[StatId]::Defense = 33
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Heavy plate armor encrusted with barnacles, very resistant to water.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
