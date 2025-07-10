using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESYLPHBOOTS
#
###############################################################################

Class BESylphBoots : BEBoots {
	BESylphBoots() : base() {
		$this.Name               = 'Sylph Boots'
		$this.MapObjName         = 'sylphboots'
		$this.PurchasePrice      = 450
		$this.SellPrice          = 225
		$this.TargetStats        = @{
			[StatId]::Defense = 13
			[StatId]::MagicDefense = 18
			[StatId]::Speed = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Light boots of an air spirit.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Female
	}
}
