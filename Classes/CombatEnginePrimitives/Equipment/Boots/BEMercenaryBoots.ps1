using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMERCENARYBOOTS
#
###############################################################################

Class BEMercenaryBoots : BEBoots {
	BEMercenaryBoots() : base() {
		$this.Name               = 'Mercenary Boots'
		$this.MapObjName         = 'mercenaryboots'
		$this.PurchasePrice      = 260
		$this.SellPrice          = 130
		$this.TargetStats        = @{
			[StatId]::Defense = 11
			[StatId]::MagicDefense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of a hired blade, practical and durable.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
