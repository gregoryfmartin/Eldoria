using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEFROSTBITEGAUNTLETS
#
###############################################################################

Class BEFrostbiteGauntlets : BEGauntlets {
	BEFrostbiteGauntlets() : base() {
		$this.Name               = 'Frostbite Gauntlets'
		$this.MapObjName         = 'frostbitegauntlets'
		$this.PurchasePrice      = 760
		$this.SellPrice          = 380
		$this.TargetStats        = @{
			[StatId]::Defense = 34
			[StatId]::MagicDefense = 17
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets radiating chilling energy, freezing foes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
