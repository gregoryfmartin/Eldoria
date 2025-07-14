using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BENIGHTFALLPAULDRON
#
###############################################################################

Class BENightfallPauldron : BEPauldron {
	BENightfallPauldron() : base() {
		$this.Name               = 'Nightfall Pauldron'
		$this.MapObjName         = 'nightfallpauldron'
		$this.PurchasePrice      = 4700
		$this.SellPrice          = 2350
		$this.TargetStats        = @{
			[StatId]::Defense = 94
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Enshrouds its wearer in perpetual twilight, aiding stealth.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
