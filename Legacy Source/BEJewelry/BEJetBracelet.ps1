using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEJETBRACELET
#
###############################################################################

Class BEJetBracelet : BEJewelry {
	BEJetBracelet() : base() {
		$this.Name               = 'Jet Bracelet'
		$this.MapObjName         = 'jetbracelet'
		$this.PurchasePrice      = 280
		$this.SellPrice          = 140
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A glossy black jet bracelet, for subtle power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Male
	}
}
