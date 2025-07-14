using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEJAILERSHELMET
#
###############################################################################

Class BEJailersHelmet : BEHelmet {
	BEJailersHelmet() : base() {
		$this.Name               = 'Jailer''s Helmet'
		$this.MapObjName         = 'jailershelmet'
		$this.PurchasePrice      = 190
		$this.SellPrice          = 95
		$this.TargetStats        = @{
			[StatId]::Defense = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sturdy helmet for jailers, protecting them from inmates.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
