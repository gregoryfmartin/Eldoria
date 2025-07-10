using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE LUMBERJACK'S CAP
#
###############################################################################

Class BELumberjacksCap : BEHelmet {
	BELumberjacksCap() : base() {
		$this.Name               = 'Lumberjack''s Cap'
		$this.MapObjName         = 'lumberjackscap'
		$this.PurchasePrice      = 80
		$this.SellPrice          = 40
		$this.TargetStats        = @{
			[StatId]::Defense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A rugged cap for lumberjacks, offering protection from falling debris.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
