using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPILGRIMSSCALLOPSHELL
#
###############################################################################

Class BEPilgrimsScallopShell : BEJewelry {
	BEPilgrimsScallopShell() : base() {
		$this.Name               = 'Pilgrim''s Scallop Shell'
		$this.MapObjName         = 'pilgrimsscallopshell'
		$this.PurchasePrice      = 550
		$this.SellPrice          = 275
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A small scallop shell, symbolizing a completed journey.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}
