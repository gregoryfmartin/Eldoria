using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESLAYERBOOTS
#
###############################################################################

Class BESlayerBoots : BEBoots {
	BESlayerBoots() : base() {
		$this.Name               = 'Slayer Boots'
		$this.MapObjName         = 'slayerboots'
		$this.PurchasePrice      = 850
		$this.SellPrice          = 425
		$this.TargetStats        = @{
			[StatId]::Defense = 35
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of a monster hunter.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
