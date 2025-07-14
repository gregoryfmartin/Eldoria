using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGLORYGREAVES
#
###############################################################################

Class BEGloryGreaves : BEGreaves {
	BEGloryGreaves() : base() {
		$this.Name               = 'Glory Greaves'
		$this.MapObjName         = 'glorygreaves'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Defense = 50
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves signifying great honor and fame.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
