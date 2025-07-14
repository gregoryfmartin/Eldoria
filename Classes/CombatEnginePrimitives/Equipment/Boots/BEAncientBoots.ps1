using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEANCIENTBOOTS
#
###############################################################################

Class BEAncientBoots : BEBoots {
	BEAncientBoots() : base() {
		$this.Name               = 'Ancient Boots'
		$this.MapObjName         = 'ancientboots'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::Defense = 53
			[StatId]::MagicDefense = 33
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots from a forgotten civilization.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
