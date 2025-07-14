using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDRYADBOOTS
#
###############################################################################

Class BEDryadBoots : BEBoots {
	BEDryadBoots() : base() {
		$this.Name               = 'Dryad Boots'
		$this.MapObjName         = 'dryadboots'
		$this.PurchasePrice      = 550
		$this.SellPrice          = 275
		$this.TargetStats        = @{
			[StatId]::Defense = 18
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots made from living wood, attuned to forests.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
