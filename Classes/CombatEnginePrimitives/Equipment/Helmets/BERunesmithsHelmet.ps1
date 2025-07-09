using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE RUNESMITH'S HELMET
#
###############################################################################

Class BERunesmithsHelmet : BEHelmet {
	BERunesmithsHelmet() : base() {
		$this.Name               = 'Runesmith''s Helmet'
		$this.MapObjName         = 'runesmithshelmet'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helmet inscribed with powerful runes, enhancing runic magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
