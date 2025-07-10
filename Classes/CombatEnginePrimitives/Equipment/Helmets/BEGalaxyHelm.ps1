using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGALAXYHELM
#
###############################################################################

Class BEGalaxyHelm : BEHelmet {
	BEGalaxyHelm() : base() {
		$this.Name               = 'Galaxy Helm'
		$this.MapObjName         = 'galaxyhelm'
		$this.PurchasePrice      = 8000
		$this.SellPrice          = 4000
		$this.TargetStats        = @{
			[StatId]::Defense = 50
			[StatId]::MagicDefense = 50
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm that contains a swirling galaxy within, granting immense power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
