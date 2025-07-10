using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECULTISTBOOTS
#
###############################################################################

Class BECultistBoots : BEBoots {
	BECultistBoots() : base() {
		$this.Name               = 'Cultist Boots'
		$this.MapObjName         = 'cultistboots'
		$this.PurchasePrice      = 650
		$this.SellPrice          = 325
		$this.TargetStats        = @{
			[StatId]::Defense = 25
			[StatId]::MagicDefense = 22
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots worn by a dark cult.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
