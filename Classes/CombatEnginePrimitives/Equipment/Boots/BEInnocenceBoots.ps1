using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEINNOCENCEBOOTS
#
###############################################################################

Class BEInnocenceBoots : BEBoots {
	BEInnocenceBoots() : base() {
		$this.Name               = 'Innocence Boots'
		$this.MapObjName         = 'innocenceboots'
		$this.PurchasePrice      = 750
		$this.SellPrice          = 375
		$this.TargetStats        = @{
			[StatId]::Defense = 27
			[StatId]::MagicDefense = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of a pure heart.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
