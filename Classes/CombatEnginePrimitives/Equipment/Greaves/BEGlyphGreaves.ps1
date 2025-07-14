using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGLYPHGREAVES
#
###############################################################################

Class BEGlyphGreaves : BEGreaves {
	BEGlyphGreaves() : base() {
		$this.Name               = 'Glyph Greaves'
		$this.MapObjName         = 'glyphgreaves'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{
			[StatId]::Defense = 38
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves adorned with powerful magical symbols.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
