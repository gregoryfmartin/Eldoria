using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BENYMPHBOOTS
#
###############################################################################

Class BENymphBoots : BEBoots {
	BENymphBoots() : base() {
		$this.Name               = 'Nymph Boots'
		$this.MapObjName         = 'nymphboots'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{
			[StatId]::Defense = 20
			[StatId]::MagicDefense = 22
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of a beautiful nature spirit.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
