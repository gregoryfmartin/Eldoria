using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPALADINBOOTS
#
###############################################################################

Class BEPaladinBoots : BEBoots {
	BEPaladinBoots() : base() {
		$this.Name               = 'Paladin Boots'
		$this.MapObjName         = 'paladinboots'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 37
			[StatId]::MagicDefense = 28
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of a holy warrior, offering divine protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
