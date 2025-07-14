using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBEASTMASTERSCAP
#
###############################################################################

Class BEBeastmastersCap : BEHelmet {
	BEBeastmastersCap() : base() {
		$this.Name               = 'Beastmaster''s Cap'
		$this.MapObjName         = 'beastmasterscap'
		$this.PurchasePrice      = 170
		$this.SellPrice          = 85
		$this.TargetStats        = @{
			[StatId]::Defense = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A rugged cap worn by beastmasters, aiding in animal taming.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
