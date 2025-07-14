using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDESTRUCTIONHELM
#
###############################################################################

Class BEDestructionHelm : BEHelmet {
	BEDestructionHelm() : base() {
		$this.Name               = 'Destruction Helm'
		$this.MapObjName         = 'destructionhelm'
		$this.PurchasePrice      = 12000
		$this.SellPrice          = 6000
		$this.TargetStats        = @{
			[StatId]::Defense = 100
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm that embodies pure destruction, increasing offensive power exponentially.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
