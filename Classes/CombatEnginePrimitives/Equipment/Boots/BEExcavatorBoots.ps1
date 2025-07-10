using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEEXCAVATORBOOTS
#
###############################################################################

Class BEExcavatorBoots : BEBoots {
	BEExcavatorBoots() : base() {
		$this.Name               = 'Excavator Boots'
		$this.MapObjName         = 'excavatorboots'
		$this.PurchasePrice      = 320
		$this.SellPrice          = 160
		$this.TargetStats        = @{
			[StatId]::Defense = 11
			[StatId]::MagicDefense = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for deep digging.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
