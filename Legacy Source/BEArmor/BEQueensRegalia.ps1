using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEQUEENSREGALIA
#
###############################################################################

Class BEQueensRegalia : BEArmor {
	BEQueensRegalia() : base() {
		$this.Name               = 'Queen''s Regalia'
		$this.MapObjName         = 'queensregalia'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 24
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'The ceremonial robes of a queen, imbued with subtle magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
