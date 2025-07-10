using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEENLIGHTENEDONESCROWN
#
###############################################################################

Class BEEnlightenedOnesCrown : BEHelmet {
	BEEnlightenedOnesCrown() : base() {
		$this.Name               = 'Enlightened One''s Crown'
		$this.MapObjName         = 'enlightenedonescrown'
		$this.PurchasePrice      = 2500
		$this.SellPrice          = 1250
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A crown worn by those who have achieved enlightenment, radiating inner peace.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
