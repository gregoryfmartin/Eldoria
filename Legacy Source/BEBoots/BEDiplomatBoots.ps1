using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDIPLOMATBOOTS
#
###############################################################################

Class BEDiplomatBoots : BEBoots {
	BEDiplomatBoots() : base() {
		$this.Name               = 'Diplomat Boots'
		$this.MapObjName         = 'diplomatboots'
		$this.PurchasePrice      = 280
		$this.SellPrice          = 140
		$this.TargetStats        = @{
			[StatId]::Defense = 9
			[StatId]::MagicDefense = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for negotiators and envoys.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
