using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE GNOMES HELMET
#
###############################################################################

Class BEGnomesHelmet : BEHelmet {
	BEGnomesHelmet() : base() {
		$this.Name               = 'Gnome''s Helmet'
		$this.MapObjName         = 'gnomeshelmet'
		$this.PurchasePrice      = 180
		$this.SellPrice          = 90
		$this.TargetStats        = @{
			[StatId]::Defense = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A small, sturdy helmet crafted by gnomes, surprisingly resilient.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
