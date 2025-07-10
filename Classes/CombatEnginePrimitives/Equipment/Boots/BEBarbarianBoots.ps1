using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBARBARIANBOOTS
#
###############################################################################

Class BEBarbarianBoots : BEBoots {
	BEBarbarianBoots() : base() {
		$this.Name               = 'Barbarian Boots'
		$this.MapObjName         = 'barbarianboots'
		$this.PurchasePrice      = 440
		$this.SellPrice          = 220
		$this.TargetStats        = @{
			[StatId]::Defense = 23
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Crude but effective boots of a barbarian.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
