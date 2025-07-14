using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEUNDINEBOOTS
#
###############################################################################

Class BEUndineBoots : BEBoots {
	BEUndineBoots() : base() {
		$this.Name               = 'Undine Boots'
		$this.MapObjName         = 'undineboots'
		$this.PurchasePrice      = 500
		$this.SellPrice          = 250
		$this.TargetStats        = @{
			[StatId]::Defense = 16
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of a water spirit.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
