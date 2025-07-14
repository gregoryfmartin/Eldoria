using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEUNICORNBOOTS
#
###############################################################################

Class BEUnicornBoots : BEBoots {
	BEUnicornBoots() : base() {
		$this.Name               = 'Unicorn Boots'
		$this.MapObjName         = 'unicornboots'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 35
			[StatId]::MagicDefense = 35
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Pure boots, associated with healing.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
