using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BENECROMANCERSROBE
#
###############################################################################

Class BENecromancersRobe : BEArmor {
	BENecromancersRobe() : base() {
		$this.Name               = 'Necromancer''s Robe'
		$this.MapObjName         = 'necromancersrobe'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 28
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A chilling robe that pulses with unholy energy, enhancing dark magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
