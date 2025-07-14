using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGRIZZLEDVETERANSGAUNTLETS
#
###############################################################################

Class BEGrizzledVeteransGauntlets : BEGauntlets {
	BEGrizzledVeteransGauntlets() : base() {
		$this.Name               = 'Grizzled Veteran''s Gauntlets'
		$this.MapObjName         = 'grizzledveteransgauntlets'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{
			[StatId]::Defense = 30
			[StatId]::MagicDefense = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets of a truly ancient warrior, scarred and strong.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
