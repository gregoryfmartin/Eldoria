using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESILKBLOUSE
#
###############################################################################

Class BESilkBlouse : BEArmor {
	BESilkBlouse() : base() {
		$this.Name               = 'Silk Blouse'
		$this.MapObjName         = 'silkblouse'
		$this.PurchasePrice      = 80
		$this.SellPrice          = 40
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A fine silk blouse, comfortable but offers no defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
