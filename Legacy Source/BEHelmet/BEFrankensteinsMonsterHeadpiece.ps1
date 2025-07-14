using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEFRANKENSTEINSMONSTERHEADPIECE
#
###############################################################################

Class BEFrankensteinsMonsterHeadpiece : BEHelmet {
	BEFrankensteinsMonsterHeadpiece() : base() {
		$this.Name               = 'Frankenstein''s Monster Headpiece'
		$this.MapObjName         = 'frankensteinsmonsterheadpiece'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{
			[StatId]::Defense = 19
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A patched-together headpiece that offers immense resilience.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
