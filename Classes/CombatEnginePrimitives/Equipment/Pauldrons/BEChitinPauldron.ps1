using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECHITINPAULDRON
#
###############################################################################

Class BEChitinPauldron : BEPauldron {
	BEChitinPauldron() : base() {
		$this.Name               = 'Chitin Pauldron'
		$this.MapObjName         = 'chitinpauldron'
		$this.PurchasePrice      = 5650
		$this.SellPrice          = 2825
		$this.TargetStats        = @{
			[StatId]::Defense = 113
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Made from the exoskeleton of a giant insect, surprisingly durable.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
