using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE DIVINER'S HEADBAND
#
###############################################################################

Class BEDivinersHeadband : BEHelmet {
	BEDivinersHeadband() : base() {
		$this.Name               = 'Diviner''s Headband'
		$this.MapObjName         = 'divinersheadband'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 17
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A headband worn by diviners, enhancing their foresight.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
