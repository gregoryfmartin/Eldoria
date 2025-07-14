using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPEGASUSBOOTS
#
###############################################################################

Class BEPegasusBoots : BEBoots {
	BEPegasusBoots() : base() {
		$this.Name               = 'Pegasus Boots'
		$this.MapObjName         = 'pegasusboots'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 30
			[StatId]::MagicDefense = 18
			[StatId]::Speed = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots that feel weightless.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}
