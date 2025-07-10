using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPROPHETBOOTS
#
###############################################################################

Class BEProphetBoots : BEBoots {
	BEProphetBoots() : base() {
		$this.Name               = 'Prophet Boots'
		$this.MapObjName         = 'prophetboots'
		$this.PurchasePrice      = 750
		$this.SellPrice          = 375
		$this.TargetStats        = @{
			[StatId]::Defense = 22
			[StatId]::MagicDefense = 32
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of a divine messenger.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
