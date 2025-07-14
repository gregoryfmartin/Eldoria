using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMONKSPRAYERBEADS
#
###############################################################################

Class BEMonksPrayerBeads : BEJewelry {
	BEMonksPrayerBeads() : base() {
		$this.Name               = 'Monk''s Prayer Beads'
		$this.MapObjName         = 'monksprayerbeads'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 1
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A small string of prayer beads, for meditation.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
