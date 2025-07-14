using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECRIMSONWITCHSGOWN
#
###############################################################################

Class BECrimsonWitchsGown : BEArmor {
	BECrimsonWitchsGown() : base() {
		$this.Name               = 'Crimson Witch''s Gown'
		$this.MapObjName         = 'crimsonwitchsgown'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A deep crimson gown, enhancing dark and fire-based magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
