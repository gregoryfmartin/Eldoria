using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEEMERALDBRACELET
#
###############################################################################

Class BEEmeraldBracelet : BEJewelry {
	BEEmeraldBracelet() : base() {
		$this.Name               = 'Emerald Bracelet'
		$this.MapObjName         = 'emeraldbracelet'
		$this.PurchasePrice      = 550
		$this.SellPrice          = 275
		$this.TargetStats        = @{
			[StatId]::Defense = 1
			[StatId]::MagicAttack = 2
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A verdant emerald bracelet, granting a touch of nature''s magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
