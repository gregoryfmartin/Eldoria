using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BENECROMANCERSBONEDUST
#
###############################################################################

Class BENecromancersBoneDust : BEJewelry {
	BENecromancersBoneDust() : base() {
		$this.Name               = 'Necromancer''s Bone Dust'
		$this.MapObjName         = 'necromancersbonedust'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A small pouch of fine bone dust, for raising the dead.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Male
	}
}
