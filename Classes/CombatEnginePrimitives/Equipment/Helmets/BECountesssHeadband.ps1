using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE COUNTESS'S HEADBAND
#
###############################################################################

Class BECountesssHeadband : BEHelmet {
	BECountesssHeadband() : base() {
		$this.Name               = 'Countess''s Headband'
		$this.MapObjName         = 'countesssheadband'
		$this.PurchasePrice      = 450
		$this.SellPrice          = 225
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A stylish headband worn by countesses, adorned with minor jewels.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
