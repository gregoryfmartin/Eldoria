using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECONSCRIPTBOOTS
#
###############################################################################

Class BEConscriptBoots : BEBoots {
	BEConscriptBoots() : base() {
		$this.Name               = 'Conscript Boots'
		$this.MapObjName         = 'conscriptboots'
		$this.PurchasePrice      = 110
		$this.SellPrice          = 55
		$this.TargetStats        = @{
			[StatId]::Defense = 4
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Basic boots for newly drafted soldiers.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
