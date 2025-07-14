using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMITHRILPAULDRON
#
###############################################################################

Class BEMithrilPauldron : BEPauldron {
	BEMithrilPauldron() : base() {
		$this.Name               = 'Mithril Pauldron'
		$this.MapObjName         = 'mithrilpauldron'
		$this.PurchasePrice      = 500
		$this.SellPrice          = 250
		$this.TargetStats        = @{
			[StatId]::Defense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Lightweight yet incredibly strong, favored by agile fighters.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
