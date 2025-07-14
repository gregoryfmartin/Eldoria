using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEFROSTFIREROBE
#
###############################################################################

Class BEFrostfireRobe : BEArmor {
	BEFrostfireRobe() : base() {
		$this.Name               = 'Frostfire Robe'
		$this.MapObjName         = 'frostfirerobe'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 35
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe that shimmers with both ice and fire, very volatile.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
