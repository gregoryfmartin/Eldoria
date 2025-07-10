using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEAPOSTATESHOOD
#
###############################################################################

Class BEApostatesHood : BEHelmet {
	BEApostatesHood() : base() {
		$this.Name               = 'Apostate''s Hood'
		$this.MapObjName         = 'apostateshood'
		$this.PurchasePrice      = 120
		$this.SellPrice          = 60
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dark hood worn by apostates, symbolizing their rejection of faith.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
