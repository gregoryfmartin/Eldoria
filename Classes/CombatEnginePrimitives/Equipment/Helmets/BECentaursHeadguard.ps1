using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECENTAURSHEADGUARD
#
###############################################################################

Class BECentaursHeadguard : BEHelmet {
	BECentaursHeadguard() : base() {
		$this.Name               = 'Centaur''s Headguard'
		$this.MapObjName         = 'centaursheadguard'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{
			[StatId]::Defense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A protective headguard designed for centaur warriors.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
