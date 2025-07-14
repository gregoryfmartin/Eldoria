using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGLORYBOOTS
#
###############################################################################

Class BEGloryBoots : BEBoots {
	BEGloryBoots() : base() {
		$this.Name               = 'Glory Boots'
		$this.MapObjName         = 'gloryboots'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::Defense = 47
			[StatId]::MagicDefense = 27
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots signifying great honor and fame.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
