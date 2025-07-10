using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEUNICORNHORNPLATE
#
###############################################################################

Class BEUnicornHornPlate : BEArmor {
	BEUnicornHornPlate() : base() {
		$this.Name               = 'Unicorn Horn Plate'
		$this.MapObjName         = 'unicornhornplate'
		$this.PurchasePrice      = 2500
		$this.SellPrice          = 1250
		$this.TargetStats        = @{
			[StatId]::Defense = 30
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Plate armor inlaid with fragments of unicorn horn, very rare.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
