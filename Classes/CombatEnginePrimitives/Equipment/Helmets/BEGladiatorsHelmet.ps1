using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE GLADIATORS HELMET
#
###############################################################################

Class BEGladiatorsHelmet : BEHelmet {
	BEGladiatorsHelmet() : base() {
		$this.Name               = 'Gladiator''s Helmet'
		$this.MapObjName         = 'gladiatorshelmet'
		$this.PurchasePrice      = 550
		$this.SellPrice          = 275
		$this.TargetStats        = @{
			[StatId]::Defense = 14
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A fearsome helmet worn by gladiators, designed for arena combat.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
