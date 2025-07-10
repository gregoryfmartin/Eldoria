using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBARBARIANSCLAWS
#
###############################################################################

Class BEBarbariansClaws : BEGauntlets {
	BEBarbariansClaws() : base() {
		$this.Name               = 'Barbarian''s Claws'
		$this.MapObjName         = 'barbariansclaws'
		$this.PurchasePrice      = 290
		$this.SellPrice          = 145
		$this.TargetStats        = @{
			[StatId]::Defense = 15
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Crude gauntlets with sharpened edges, for close combat.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
