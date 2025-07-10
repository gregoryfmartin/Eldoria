using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMOONFALLBANDS
#
###############################################################################

Class BEMoonfallBands : BEGauntlets {
	BEMoonfallBands() : base() {
		$this.Name               = 'Moonfall Bands'
		$this.MapObjName         = 'moonfallbands'
		$this.PurchasePrice      = 490
		$this.SellPrice          = 245
		$this.TargetStats        = @{
			[StatId]::Defense = 12
			[StatId]::MagicDefense = 22
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Bands that softly glow, absorbing lunar energy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
