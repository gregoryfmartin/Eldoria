using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBARBARIANSSKULLCAP
#
###############################################################################

Class BEBarbariansSkullcap : BEHelmet {
	BEBarbariansSkullcap() : base() {
		$this.Name               = 'Barbarian''s Skullcap'
		$this.MapObjName         = 'barbariansskullcap'
		$this.PurchasePrice      = 200
		$this.SellPrice          = 100
		$this.TargetStats        = @{
			[StatId]::Defense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A crude skullcap fashioned from animal hide, favored by fierce barbarians.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
