using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEARCHERSHOOD
#
###############################################################################

Class BEArchersHood : BEHelmet {
	BEArchersHood() : base() {
		$this.Name               = 'Archer''s Hood'
		$this.MapObjName         = 'archershood'
		$this.PurchasePrice      = 100
		$this.SellPrice          = 50
		$this.TargetStats        = @{
			[StatId]::Defense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A light hood that provides camouflage and enhances an archer''s precision.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
