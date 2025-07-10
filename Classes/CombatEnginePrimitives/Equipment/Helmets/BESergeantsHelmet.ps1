using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESERGEANTSHELMET
#
###############################################################################

Class BESergeantsHelmet : BEHelmet {
	BESergeantsHelmet() : base() {
		$this.Name               = 'Sergeant''s Helmet'
		$this.MapObjName         = 'sergeantshelmet'
		$this.PurchasePrice      = 250
		$this.SellPrice          = 125
		$this.TargetStats        = @{
			[StatId]::Defense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A practical helmet worn by sergeants, designed for frontline leadership.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
