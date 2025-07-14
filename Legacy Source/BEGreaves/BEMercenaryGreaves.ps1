using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMERCENARYGREAVES
#
###############################################################################

Class BEMercenaryGreaves : BEGreaves {
	BEMercenaryGreaves() : base() {
		$this.Name               = 'Mercenary Greaves'
		$this.MapObjName         = 'mercenarygreaves'
		$this.PurchasePrice      = 280
		$this.SellPrice          = 140
		$this.TargetStats        = @{
			[StatId]::Defense = 13
			[StatId]::MagicDefense = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves of a hired blade, practical and durable.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
