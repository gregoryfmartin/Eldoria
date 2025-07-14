using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEURBANRANGERPAULDRON
#
###############################################################################

Class BEUrbanRangerPauldron : BEPauldron {
	BEUrbanRangerPauldron() : base() {
		$this.Name               = 'Urban Ranger Pauldron'
		$this.MapObjName         = 'urbanrangerpauldron'
		$this.PurchasePrice      = 8900
		$this.SellPrice          = 4450
		$this.TargetStats        = @{
			[StatId]::Defense = 178
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Blends into city environments, aiding stealth and surveillance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
