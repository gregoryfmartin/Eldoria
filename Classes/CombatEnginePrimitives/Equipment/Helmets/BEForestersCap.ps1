using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE FORESTER'S CAP
#
###############################################################################

Class BEForestersCap : BEHelmet {
	BEForestersCap() : base() {
		$this.Name               = 'Forester''s Cap'
		$this.MapObjName         = 'foresterscap'
		$this.PurchasePrice      = 80
		$this.SellPrice          = 40
		$this.TargetStats        = @{
			[StatId]::Defense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A cap for foresters, blending in with nature and providing light protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
