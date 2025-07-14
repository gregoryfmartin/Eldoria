using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BENEBULACLOUDPIN
#
###############################################################################

Class BENebulaCloudPin : BEJewelry {
	BENebulaCloudPin() : base() {
		$this.Name               = 'Nebula Cloud Pin'
		$this.MapObjName         = 'nebulacloudpin'
		$this.PurchasePrice      = 1750
		$this.SellPrice          = 875
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 3
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A pin with a swirling nebula trapped within.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
