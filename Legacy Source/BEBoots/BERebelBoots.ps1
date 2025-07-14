using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEREBELBOOTS
#
###############################################################################

Class BERebelBoots : BEBoots {
	BERebelBoots() : base() {
		$this.Name               = 'Rebel Boots'
		$this.MapObjName         = 'rebelboots'
		$this.PurchasePrice      = 550
		$this.SellPrice          = 275
		$this.TargetStats        = @{
			[StatId]::Defense = 22
			[StatId]::MagicDefense = 13
			[StatId]::Speed = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of resistance fighters.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}
