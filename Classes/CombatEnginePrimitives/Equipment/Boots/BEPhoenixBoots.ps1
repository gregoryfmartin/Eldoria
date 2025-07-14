using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPHOENIXBOOTS
#
###############################################################################

Class BEPhoenixBoots : BEBoots {
	BEPhoenixBoots() : base() {
		$this.Name               = 'Phoenix Boots'
		$this.MapObjName         = 'phoenixboots'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::Defense = 50
			[StatId]::MagicDefense = 32
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots that glow with fiery essence.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
