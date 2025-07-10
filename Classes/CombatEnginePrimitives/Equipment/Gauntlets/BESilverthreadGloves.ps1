using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESILVERTHREADGLOVES
#
###############################################################################

Class BESilverthreadGloves : BEGauntlets {
	BESilverthreadGloves() : base() {
		$this.Name               = 'Silverthread Gloves'
		$this.MapObjName         = 'silverthreadgloves'
		$this.PurchasePrice      = 320
		$this.SellPrice          = 160
		$this.TargetStats        = @{
			[StatId]::Defense = 8
			[StatId]::MagicDefense = 14
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves woven with fine silver thread, light and defensive against dark magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
