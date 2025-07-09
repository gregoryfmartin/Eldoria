using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE NIGHTFALL HELM
#
###############################################################################

Class BENightfallHelm : BEHelmet {
	BENightfallHelm() : base() {
		$this.Name               = 'Nightfall Helm'
		$this.MapObjName         = 'nightfallhelm'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::Defense = 15
			[StatId]::MagicDefense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm as dark as night, granting stealth and improved vision in darkness.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
