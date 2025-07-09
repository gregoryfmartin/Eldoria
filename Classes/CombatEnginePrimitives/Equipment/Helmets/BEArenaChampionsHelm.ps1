using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE ARENA CHAMPION'S HELM
#
###############################################################################

Class BEArenaChampionsHelm : BEHelmet {
	BEArenaChampionsHelm() : base() {
		$this.Name               = 'Arena Champion''s Helm'
		$this.MapObjName         = 'arenachampionshelm'
		$this.PurchasePrice      = 1900
		$this.SellPrice          = 950
		$this.TargetStats        = @{
			[StatId]::Defense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A fearsome helm worn by arena champions, inspiring awe and fear.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
