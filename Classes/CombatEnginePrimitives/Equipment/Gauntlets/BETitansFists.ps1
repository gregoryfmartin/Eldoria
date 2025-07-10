using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BETITANSFISTS
#
###############################################################################

Class BETitansFists : BEGauntlets {
	BETitansFists() : base() {
		$this.Name               = 'Titan''s Fists'
		$this.MapObjName         = 'titansfists'
		$this.PurchasePrice      = 850
		$this.SellPrice          = 425
		$this.TargetStats        = @{
			[StatId]::Defense = 40
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Massive gauntlets rumored to be from a giant.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
