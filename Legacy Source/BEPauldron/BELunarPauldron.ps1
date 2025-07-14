using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BELUNARPAULDRON
#
###############################################################################

Class BELunarPauldron : BEPauldron {
	BELunarPauldron() : base() {
		$this.Name               = 'Lunar Pauldron'
		$this.MapObjName         = 'lunarpauldron'
		$this.PurchasePrice      = 4400
		$this.SellPrice          = 2200
		$this.TargetStats        = @{
			[StatId]::Defense = 88
			[StatId]::MagicDefense = 29
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Shimmers with moonlight, enhancing night-based defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
