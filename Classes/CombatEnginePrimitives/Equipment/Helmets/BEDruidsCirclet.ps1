using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDRUIDSCIRCLET
#
###############################################################################

Class BEDruidsCirclet : BEHelmet {
	BEDruidsCirclet() : base() {
		$this.Name               = 'Druid''s Circlet'
		$this.MapObjName         = 'druidscirclet'
		$this.PurchasePrice      = 250
		$this.SellPrice          = 125
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A nature-infused circlet that boosts connection to the earth''s magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
