using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBARDPAULDRON
#
###############################################################################

Class BEBardPauldron : BEPauldron {
	BEBardPauldron() : base() {
		$this.Name               = 'Bard Pauldron'
		$this.MapObjName         = 'bardpauldron'
		$this.PurchasePrice      = 7900
		$this.SellPrice          = 3950
		$this.TargetStats        = @{
			[StatId]::Defense = 158
			[StatId]::MagicDefense = 78
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Inspires allies and demoralizes enemies through song.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
