using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE TRANSMUTER'S HOOD
#
###############################################################################

Class BETransmutersHood : BEHelmet {
	BETransmutersHood() : base() {
		$this.Name               = 'Transmuter''s Hood'
		$this.MapObjName         = 'transmutershood'
		$this.PurchasePrice      = 1900
		$this.SellPrice          = 950
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 21
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A hood worn by transmuters, aiding in altering physical properties.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
