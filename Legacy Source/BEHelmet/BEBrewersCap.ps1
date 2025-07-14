using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBREWERSCAP
#
###############################################################################

Class BEBrewersCap : BEHelmet {
	BEBrewersCap() : base() {
		$this.Name               = 'Brewer''s Cap'
		$this.MapObjName         = 'brewerscap'
		$this.PurchasePrice      = 70
		$this.SellPrice          = 35
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A traditional cap worn by brewers, ensuring good spirits.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
