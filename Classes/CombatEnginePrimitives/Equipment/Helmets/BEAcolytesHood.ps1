using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE ACOLYTES HOOD
#
###############################################################################

Class BEAcolytesHood : BEHelmet {
	BEAcolytesHood() : base() {
		$this.Name               = 'Acolyte''s Hood'
		$this.MapObjName         = 'acolyteshood'
		$this.PurchasePrice      = 70
		$this.SellPrice          = 35
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A humble hood worn by acolytes, signifying their dedication.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
