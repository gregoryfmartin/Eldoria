using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEFIENDBOOTS
#
###############################################################################

Class BEFiendBoots : BEBoots {
	BEFiendBoots() : base() {
		$this.Name               = 'Fiend Boots'
		$this.MapObjName         = 'fiendboots'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::Defense = 55
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of a malevolent spirit.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
