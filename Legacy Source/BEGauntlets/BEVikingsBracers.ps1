using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEVIKINGSBRACERS
#
###############################################################################

Class BEVikingsBracers : BEGauntlets {
	BEVikingsBracers() : base() {
		$this.Name               = 'Viking''s Bracers'
		$this.MapObjName         = 'vikingsbracers'
		$this.PurchasePrice      = 330
		$this.SellPrice          = 165
		$this.TargetStats        = @{
			[StatId]::Defense = 16
			[StatId]::MagicDefense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Sturdy bracers for a seafaring warrior.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
