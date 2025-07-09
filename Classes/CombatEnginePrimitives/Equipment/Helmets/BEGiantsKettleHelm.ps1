using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE GIANT'S KETTLE HELM
#
###############################################################################

Class BEGiantsKettleHelm : BEHelmet {
	BEGiantsKettleHelm() : base() {
		$this.Name               = 'Giant''s Kettle Helm'
		$this.MapObjName         = 'giantskettlehelm'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::Defense = 14
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A colossal helm made from a giant''s kettle, providing immense defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
