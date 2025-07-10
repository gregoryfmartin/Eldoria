using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESHADOWBOOTS
#
###############################################################################

Class BEShadowBoots : BEBoots {
	BEShadowBoots() : base() {
		$this.Name               = 'Shadow Boots'
		$this.MapObjName         = 'shadowboots'
		$this.PurchasePrice      = 850
		$this.SellPrice          = 425
		$this.TargetStats        = @{
			[StatId]::Defense = 25
			[StatId]::MagicDefense = 25
			[StatId]::Speed = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots imbued with dark energies, granting stealth.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Male
	}
}
