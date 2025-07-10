using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESORCERESSSVEIL
#
###############################################################################

Class BESorceresssVeil : BEHelmet {
	BESorceresssVeil() : base() {
		$this.Name               = 'Sorceress''s Veil'
		$this.MapObjName         = 'sorceresssveil'
		$this.PurchasePrice      = 850
		$this.SellPrice          = 425
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 13
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A mysterious veil that conceals the wearer''s identity and enhances dark magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
