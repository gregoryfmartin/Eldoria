using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE EXPLORER'S PITH HELMET
#
###############################################################################

Class BEExplorersPithHelmet : BEHelmet {
	BEExplorersPithHelmet() : base() {
		$this.Name               = 'Explorer''s Pith Helmet'
		$this.MapObjName         = 'explorerspithhelmet'
		$this.PurchasePrice      = 120
		$this.SellPrice          = 60
		$this.TargetStats        = @{
			[StatId]::Defense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A classic pith helmet for explorers, offering sun protection in exotic lands.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
