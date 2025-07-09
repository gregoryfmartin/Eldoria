using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE LEPRECHAUN'S TOP HAT
#
###############################################################################

Class BELeprechaunsTopHat : BEHelmet {
	BELeprechaunsTopHat() : base() {
		$this.Name               = 'Leprechaun''s Top Hat'
		$this.MapObjName         = 'leprechaunstophat'
		$this.PurchasePrice      = 100
		$this.SellPrice          = 50
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A charming top hat that brings good luck.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
