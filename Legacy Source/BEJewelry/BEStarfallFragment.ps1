using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESTARFALLFRAGMENT
#
###############################################################################

Class BEStarfallFragment : BEJewelry {
	BEStarfallFragment() : base() {
		$this.Name               = 'Starfall Fragment'
		$this.MapObjName         = 'starfallfragment'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{
			[StatId]::Speed = 3
			[StatId]::Luck = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A fragment of a fallen star, shimmering with cosmic energy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Speed]) SPD  +$($this.TargetStats[[StatId]::Luck]) LCK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
