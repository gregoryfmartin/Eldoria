using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEVOIDHEARTGRIPS
#
###############################################################################

Class BEVoidheartGrips : BEGauntlets {
	BEVoidheartGrips() : base() {
		$this.Name               = 'Voidheart Grips'
		$this.MapObjName         = 'voidheartgrips'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{
			[StatId]::Defense = 82
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Grips that feel cold to the touch, connected to the void.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
