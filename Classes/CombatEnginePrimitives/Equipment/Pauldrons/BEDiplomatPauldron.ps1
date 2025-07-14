using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDIPLOMATPAULDRON
#
###############################################################################

Class BEDiplomatPauldron : BEPauldron {
	BEDiplomatPauldron() : base() {
		$this.Name               = 'Diplomat Pauldron'
		$this.MapObjName         = 'diplomatpauldron'
		$this.PurchasePrice      = 9850
		$this.SellPrice          = 4925
		$this.TargetStats        = @{
			[StatId]::Defense = 197
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Enhances charisma and negotiation skills, aiding in peaceful resolutions.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
