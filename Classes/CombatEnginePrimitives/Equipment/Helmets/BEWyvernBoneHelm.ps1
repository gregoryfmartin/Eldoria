using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE WYVERN BONE HELM
#
###############################################################################

Class BEWyvernBoneHelm : BEHelmet {
	BEWyvernBoneHelm() : base() {
		$this.Name               = 'Wyvern Bone Helm'
		$this.MapObjName         = 'wyvernbonehelm'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::Defense = 16
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A rugged helm fashioned from wyvern bones, imparting a primal ferocity.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
