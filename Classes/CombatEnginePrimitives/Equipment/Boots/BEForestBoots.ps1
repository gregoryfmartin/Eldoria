using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEFORESTBOOTS
#
###############################################################################

Class BEForestBoots : BEBoots {
	BEForestBoots() : base() {
		$this.Name               = 'Forest Boots'
		$this.MapObjName         = 'forestboots'
		$this.PurchasePrice      = 460
		$this.SellPrice          = 230
		$this.TargetStats        = @{
			[StatId]::Defense = 15
			[StatId]::MagicDefense = 13
			[StatId]::Speed = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots that blend with natural surroundings.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}
