using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBRIGANDINEHELMET
#
###############################################################################

Class BEBrigandineHelmet : BEHelmet {
	BEBrigandineHelmet() : base() {
		$this.Name               = 'Brigandine Helmet'
		$this.MapObjName         = 'brigandinehelmet'
		$this.PurchasePrice      = 220
		$this.SellPrice          = 110
		$this.TargetStats        = @{
			[StatId]::Defense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helmet reinforced with metal plates, offering improved defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
