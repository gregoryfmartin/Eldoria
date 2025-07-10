using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBONEPLATE
#
###############################################################################

Class BEBonePlate : BEArmor {
	BEBonePlate() : base() {
		$this.Name               = 'Bone Plate'
		$this.MapObjName         = 'boneplate'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{
			[StatId]::Defense = 13
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Armor crafted from hardened bones, eerie but effective.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
