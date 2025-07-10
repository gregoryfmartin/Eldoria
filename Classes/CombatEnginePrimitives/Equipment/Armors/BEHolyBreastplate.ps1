using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEHOLYBREASTPLATE
#
###############################################################################

Class BEHolyBreastplate : BEArmor {
	BEHolyBreastplate() : base() {
		$this.Name               = 'Holy Breastplate'
		$this.MapObjName         = 'holybreastplate'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
			[StatId]::Defense = 17
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A breastplate blessed by the church, resisting dark attacks.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
