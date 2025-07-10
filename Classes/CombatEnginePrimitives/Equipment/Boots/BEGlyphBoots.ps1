using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGLYPHBOOTS
#
###############################################################################

Class BEGlyphBoots : BEBoots {
	BEGlyphBoots() : base() {
		$this.Name               = 'Glyph Boots'
		$this.MapObjName         = 'glyphboots'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::Defense = 35
			[StatId]::MagicDefense = 27
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots adorned with powerful magical symbols.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
