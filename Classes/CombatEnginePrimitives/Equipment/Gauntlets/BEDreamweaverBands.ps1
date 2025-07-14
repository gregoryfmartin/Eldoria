using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDREAMWEAVERBANDS
#
###############################################################################

Class BEDreamweaverBands : BEGauntlets {
	BEDreamweaverBands() : base() {
		$this.Name               = 'Dreamweaver Bands'
		$this.MapObjName         = 'dreamweaverbands'
		$this.PurchasePrice      = 830
		$this.SellPrice          = 415
		$this.TargetStats        = @{
			[StatId]::Defense = 13
			[StatId]::MagicDefense = 34
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Bands that allow the wearer to influence dreams and minds.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
