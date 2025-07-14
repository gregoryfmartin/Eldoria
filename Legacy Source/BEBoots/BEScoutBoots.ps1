using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESCOUTBOOTS
#
###############################################################################

Class BEScoutBoots : BEBoots {
	BEScoutBoots() : base() {
		$this.Name               = 'Scout Boots'
		$this.MapObjName         = 'scoutboots'
		$this.PurchasePrice      = 280
		$this.SellPrice          = 140
		$this.TargetStats        = @{
			[StatId]::Defense = 8
			[StatId]::MagicDefense = 7
			[StatId]::Speed = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Light boots for quick movement and evasion.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}
