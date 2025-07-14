using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDRAGONTURTLESHELLHELM
#
###############################################################################

Class BEDragonTurtleShellHelm : BEHelmet {
	BEDragonTurtleShellHelm() : base() {
		$this.Name               = 'Dragon Turtle Shell Helm'
		$this.MapObjName         = 'dragonturtleshellhelm'
		$this.PurchasePrice      = 2200
		$this.SellPrice          = 1100
		$this.TargetStats        = @{
			[StatId]::Defense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A massive helm made from a dragon turtle''s shell, offering exceptional defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
