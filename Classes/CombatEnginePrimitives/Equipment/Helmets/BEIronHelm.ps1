using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEIRONHELM
#
###############################################################################

Class BEIronHelm : BEHelmet {
	BEIronHelm() : base() {
		$this.Name               = 'Iron Helm'
		$this.MapObjName         = 'ironhelm'
		$this.PurchasePrice      = 120
		$this.SellPrice          = 60
		$this.TargetStats        = @{
			[StatId]::Defense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sturdy iron helmet, common among foot soldiers.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
