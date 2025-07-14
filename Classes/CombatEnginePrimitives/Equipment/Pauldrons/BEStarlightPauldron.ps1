using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESTARLIGHTPAULDRON
#
###############################################################################

Class BEStarlightPauldron : BEPauldron {
	BEStarlightPauldron() : base() {
		$this.Name               = 'Starlight Pauldron'
		$this.MapObjName         = 'starlightpauldron'
		$this.PurchasePrice      = 4500
		$this.SellPrice          = 2250
		$this.TargetStats        = @{
			[StatId]::Defense = 90
			[StatId]::MagicDefense = 31
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Embedded with shimmering stardust, for celestial magic users.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
