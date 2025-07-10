using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWISDOMGIVERSHELM
#
###############################################################################

Class BEWisdomGiversHelm : BEHelmet {
	BEWisdomGiversHelm() : base() {
		$this.Name               = 'Wisdom Giver''s Helm'
		$this.MapObjName         = 'wisdomgivershelm'
		$this.PurchasePrice      = 11000
		$this.SellPrice          = 5500
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 100
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm that grants profound wisdom, allowing the wearer to see beyond.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
