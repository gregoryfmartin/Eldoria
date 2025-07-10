using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEHOLYBOOTS
#
###############################################################################

Class BEHolyBoots : BEBoots {
	BEHolyBoots() : base() {
		$this.Name               = 'Holy Boots'
		$this.MapObjName         = 'holyboots'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{
			[StatId]::Defense = 29
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Blessed boots that ward off evil.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
