using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPHANTOMROBE
#
###############################################################################

Class BEPhantomRobe : BEArmor {
	BEPhantomRobe() : base() {
		$this.Name               = 'Phantom Robe'
		$this.MapObjName         = 'phantomrobe'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 35
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe that makes the wearer partially incorporeal, enhancing evasion.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
