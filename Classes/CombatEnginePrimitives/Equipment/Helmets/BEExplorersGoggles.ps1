using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE EXPLORER'S GOGGLES
#
###############################################################################

Class BEExplorersGoggles : BEHelmet {
	BEExplorersGoggles() : base() {
		$this.Name               = 'Explorer''s Goggles'
		$this.MapObjName         = 'explorersgoggles'
		$this.PurchasePrice      = 100
		$this.SellPrice          = 50
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Goggles that aid explorers in spotting hidden details.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
