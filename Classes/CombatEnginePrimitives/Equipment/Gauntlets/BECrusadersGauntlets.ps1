using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECRUSADERSGAUNTLETS
#
###############################################################################

Class BECrusadersGauntlets : BEGauntlets {
	BECrusadersGauntlets() : base() {
		$this.Name               = 'Crusader''s Gauntlets'
		$this.MapObjName         = 'crusadersgauntlets'
		$this.PurchasePrice      = 650
		$this.SellPrice          = 325
		$this.TargetStats        = @{
			[StatId]::Defense = 30
			[StatId]::MagicDefense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Heavy, ornate gauntlets for a holy warrior.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
