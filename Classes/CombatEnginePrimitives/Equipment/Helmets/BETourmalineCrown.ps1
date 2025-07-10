using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BETOURMALINECROWN
#
###############################################################################

Class BETourmalineCrown : BEHelmet {
	BETourmalineCrown() : base() {
		$this.Name               = 'Tourmaline Crown'
		$this.MapObjName         = 'tourmalinecrown'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 19
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A crown with a multi-colored tourmaline, granting resistance to various elemental attacks.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
