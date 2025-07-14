using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPROPHETSHEADWRAP
#
###############################################################################

Class BEProphetsHeadwrap : BEHelmet {
	BEProphetsHeadwrap() : base() {
		$this.Name               = 'Prophet''s Headwrap'
		$this.MapObjName         = 'prophetsheadwrap'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 16
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A simple headwrap worn by prophets, aiding in divine communication.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
