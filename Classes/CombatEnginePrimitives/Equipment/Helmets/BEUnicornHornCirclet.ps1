using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE UNICORN HORN CIRCLET
#
###############################################################################

Class BEUnicornHornCirclet : BEHelmet {
	BEUnicornHornCirclet() : base() {
		$this.Name               = 'Unicorn Horn Circlet'
		$this.MapObjName         = 'unicornhorncirclet'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A pure circlet with a small unicorn horn, enhancing healing and purity.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
