using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGUARDIANSAEGIS
#
###############################################################################

Class BEGuardiansAegis : BEJewelry {
	BEGuardiansAegis() : base() {
		$this.Name               = 'Guardian''s Aegis'
		$this.MapObjName         = 'guardiansaegis'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Defense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A small shield shaped amulet, for staunch defenders.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
