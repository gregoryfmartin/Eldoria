using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEIRONGAUNTLETS
#
###############################################################################

Class BEIronGauntlets : BEGauntlets {
	BEIronGauntlets() : base() {
		$this.Name               = 'Iron Gauntlets'
		$this.MapObjName         = 'irongauntlets'
		$this.PurchasePrice      = 100
		$this.SellPrice          = 50
		$this.TargetStats        = @{
			[StatId]::Defense = 5
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Standard blacksmith-forged gauntlets, offering basic protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
