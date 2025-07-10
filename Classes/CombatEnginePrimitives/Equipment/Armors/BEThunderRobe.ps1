using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BETHUNDERROBE
#
###############################################################################

Class BEThunderRobe : BEArmor {
	BEThunderRobe() : base() {
		$this.Name               = 'Thunder Robe'
		$this.MapObjName         = 'thunderrobe'
		$this.PurchasePrice      = 1250
		$this.SellPrice          = 625
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 27
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe that crackles with static, enhancing lightning spells.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
