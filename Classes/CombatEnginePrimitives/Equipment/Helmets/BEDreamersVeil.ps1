using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDREAMERSVEIL
#
###############################################################################

Class BEDreamersVeil : BEHelmet {
	BEDreamersVeil() : base() {
		$this.Name               = 'Dreamer''s Veil'
		$this.MapObjName         = 'dreamersveil'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A veil that allows the wearer to enter and manipulate dreams.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
