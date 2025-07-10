using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESCHOLARPAULDRON
#
###############################################################################

Class BEScholarPauldron : BEPauldron {
	BEScholarPauldron() : base() {
		$this.Name               = 'Scholar Pauldron'
		$this.MapObjName         = 'scholarpauldron'
		$this.PurchasePrice      = 9600
		$this.SellPrice          = 4800
		$this.TargetStats        = @{
			[StatId]::Defense = 192
			[StatId]::MagicDefense = 84
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Enhances knowledge and understanding, aiding in magical research.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
