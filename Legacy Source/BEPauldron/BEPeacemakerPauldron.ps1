using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPEACEMAKERPAULDRON
#
###############################################################################

Class BEPeacemakerPauldron : BEPauldron {
	BEPeacemakerPauldron() : base() {
		$this.Name               = 'Peacemaker Pauldron'
		$this.MapObjName         = 'peacemakerpauldron'
		$this.PurchasePrice      = 9950
		$this.SellPrice          = 4975
		$this.TargetStats        = @{
			[StatId]::Defense = 199
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A symbol of hope and unity, capable of calming volatile situations.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
