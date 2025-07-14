using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESPECTERPAULDRON
#
###############################################################################

Class BESpecterPauldron : BEPauldron {
	BESpecterPauldron() : base() {
		$this.Name               = 'Specter Pauldron'
		$this.MapObjName         = 'specterpauldron'
		$this.PurchasePrice      = 5000
		$this.SellPrice          = 2500
		$this.TargetStats        = @{
			[StatId]::Defense = 100
			[StatId]::MagicDefense = 38
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A chilling relic, enhancing fear-inducing defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
