using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGOLIATHPAULDRON
#
###############################################################################

Class BEGoliathPauldron : BEPauldron {
	BEGoliathPauldron() : base() {
		$this.Name               = 'Goliath Pauldron'
		$this.MapObjName         = 'goliathpauldron'
		$this.PurchasePrice      = 3250
		$this.SellPrice          = 1625
		$this.TargetStats        = @{
			[StatId]::Defense = 65
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Named after the giants of old, granting incredible resilience.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
