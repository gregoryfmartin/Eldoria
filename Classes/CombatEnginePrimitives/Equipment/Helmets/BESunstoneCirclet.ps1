using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESUNSTONECIRCLET
#
###############################################################################

Class BESunstoneCirclet : BEHelmet {
	BESunstoneCirclet() : base() {
		$this.Name               = 'Sunstone Circlet'
		$this.MapObjName         = 'sunstonecirclet'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A radiant circlet made of sunstone, imbued with healing light.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
