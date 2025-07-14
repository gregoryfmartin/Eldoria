using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESHADOWGREAVES
#
###############################################################################

Class BEShadowGreaves : BEGreaves {
	BEShadowGreaves() : base() {
		$this.Name               = 'Shadow Greaves'
		$this.MapObjName         = 'shadowgreaves'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::Defense = 28
			[StatId]::MagicDefense = 28
			[StatId]::Speed = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves imbued with dark energies, granting stealth.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Male
	}
}
