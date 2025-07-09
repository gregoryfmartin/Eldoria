using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE DRYADS WREATH
#
###############################################################################

Class BEDryadsWreath : BEHelmet {
	BEDryadsWreath() : base() {
		$this.Name               = 'Dryad''s Wreath'
		$this.MapObjName         = 'dryadswreath'
		$this.PurchasePrice      = 250
		$this.SellPrice          = 125
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A beautiful wreath of living plants worn by dryads, connecting them to nature.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
