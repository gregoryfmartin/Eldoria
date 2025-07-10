using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECURSEDHEADBAND
#
###############################################################################

Class BECursedHeadband : BEHelmet {
	BECursedHeadband() : base() {
		$this.Name               = 'Cursed Headband'
		$this.MapObjName         = 'cursedheadband'
		$this.PurchasePrice      = 70
		$this.SellPrice          = 35
		$this.TargetStats        = @{
			[StatId]::Defense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A headband imbued with a minor curse, granting some power at a cost.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
