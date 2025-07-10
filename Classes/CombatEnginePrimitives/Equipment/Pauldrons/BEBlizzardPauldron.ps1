using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBLIZZARDPAULDRON
#
###############################################################################

Class BEBlizzardPauldron : BEPauldron {
	BEBlizzardPauldron() : base() {
		$this.Name               = 'Blizzard Pauldron'
		$this.MapObjName         = 'blizzardpauldron'
		$this.PurchasePrice      = 3850
		$this.SellPrice          = 1925
		$this.TargetStats        = @{
			[StatId]::Defense = 77
			[StatId]::MagicDefense = 22
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Summons icy winds to buffet foes, enhancing cold defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
