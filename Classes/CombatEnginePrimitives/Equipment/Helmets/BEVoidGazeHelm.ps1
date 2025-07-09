using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE VOID GAZE HELM
#
###############################################################################

Class BEVoidGazeHelm : BEHelmet {
	BEVoidGazeHelm() : base() {
		$this.Name               = 'Void Gaze Helm'
		$this.MapObjName         = 'voidgazehelm'
		$this.PurchasePrice      = 2700
		$this.SellPrice          = 1350
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 23
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm that allows the wearer to glimpse into the void, potentially driving them mad.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
