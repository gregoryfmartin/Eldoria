using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE INQUISITOR'S HOOD
#
###############################################################################

Class BEInquisitorsHood : BEHelmet {
	BEInquisitorsHood() : base() {
		$this.Name               = 'Inquisitor''s Hood'
		$this.MapObjName         = 'inquisitorshood'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A somber hood worn by inquisitors, projecting authority and sternness.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
