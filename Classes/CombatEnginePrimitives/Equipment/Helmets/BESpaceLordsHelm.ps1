using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESPACELORDSHELM
#
###############################################################################

Class BESpaceLordsHelm : BEHelmet {
	BESpaceLordsHelm() : base() {
		$this.Name               = 'Space Lord''s Helm'
		$this.MapObjName         = 'spacelordshelm'
		$this.PurchasePrice      = 15000
		$this.SellPrice          = 7500
		$this.TargetStats        = @{
			[StatId]::Defense = 75
			[StatId]::MagicDefense = 75
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm that grants absolute control over space, allowing teleportation and reality warping.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
