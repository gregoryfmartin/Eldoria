using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BERUNEOFPROTECTIONHELM
#
###############################################################################

Class BERuneofProtectionHelm : BEHelmet {
	BERuneofProtectionHelm() : base() {
		$this.Name               = 'Rune of Protection Helm'
		$this.MapObjName         = 'runeofprotectionhelm'
		$this.PurchasePrice      = 1900
		$this.SellPrice          = 950
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm inscribed with a rune of protection, significantly increasing defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
