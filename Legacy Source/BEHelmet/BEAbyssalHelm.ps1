using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEABYSSALHELM
#
###############################################################################

Class BEAbyssalHelm : BEHelmet {
	BEAbyssalHelm() : base() {
		$this.Name               = 'Abyssal Helm'
		$this.MapObjName         = 'abyssalhelm'
		$this.PurchasePrice      = 4300
		$this.SellPrice          = 2150
		$this.TargetStats        = @{
			[StatId]::Defense = 38
			[StatId]::MagicDefense = 28
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm from the darkest depths of the abyss, granting unholy power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
