using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGHOSTBOOTS
#
###############################################################################

Class BEGhostBoots : BEBoots {
	BEGhostBoots() : base() {
		$this.Name               = 'Ghost Boots'
		$this.MapObjName         = 'ghostboots'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 27
			[StatId]::MagicDefense = 40
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Ethereal boots, difficult to hit.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
