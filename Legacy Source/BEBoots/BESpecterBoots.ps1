using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESPECTERBOOTS
#
###############################################################################

Class BESpecterBoots : BEBoots {
	BESpecterBoots() : base() {
		$this.Name               = 'Specter Boots'
		$this.MapObjName         = 'specterboots'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 32
			[StatId]::MagicDefense = 45
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of a powerful phantom.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
