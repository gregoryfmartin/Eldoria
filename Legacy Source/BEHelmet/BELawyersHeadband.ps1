using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BELAWYERSHEADBAND
#
###############################################################################

Class BELawyersHeadband : BEHelmet {
	BELawyersHeadband() : base() {
		$this.Name               = 'Lawyer''s Headband'
		$this.MapObjName         = 'lawyersheadband'
		$this.PurchasePrice      = 80
		$this.SellPrice          = 40
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A modest headband for lawyers, aiding in quick thinking.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
