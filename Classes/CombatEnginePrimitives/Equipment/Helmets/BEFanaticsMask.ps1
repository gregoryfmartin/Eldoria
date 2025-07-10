using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEFANATICSMASK
#
###############################################################################

Class BEFanaticsMask : BEHelmet {
	BEFanaticsMask() : base() {
		$this.Name               = 'Fanatic''s Mask'
		$this.MapObjName         = 'fanaticsmask'
		$this.PurchasePrice      = 200
		$this.SellPrice          = 100
		$this.TargetStats        = @{
			[StatId]::Defense = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A terrifying mask worn by fanatics, inspiring fear and unwavering loyalty.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
