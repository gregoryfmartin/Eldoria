using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBONEEARRING
#
###############################################################################

Class BEBoneEarring : BEJewelry {
	BEBoneEarring() : base() {
		$this.Name               = 'Bone Earring'
		$this.MapObjName         = 'boneearring'
		$this.PurchasePrice      = 100
		$this.SellPrice          = 50
		$this.TargetStats        = @{
			[StatId]::Attack = 1
			[StatId]::Accuracy = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An earring crafted from polished bone.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Male
	}
}
