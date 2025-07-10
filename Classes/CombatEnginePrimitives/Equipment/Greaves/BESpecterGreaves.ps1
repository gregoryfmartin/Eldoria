using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESPECTERGREAVES
#
###############################################################################

Class BESpecterGreaves : BEGreaves {
	BESpecterGreaves() : base() {
		$this.Name               = 'Specter Greaves'
		$this.MapObjName         = 'spectergreaves'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::Defense = 35
			[StatId]::MagicDefense = 50
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves of a powerful phantom.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
