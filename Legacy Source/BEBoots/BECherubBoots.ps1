using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECHERUBBOOTS
#
###############################################################################

Class BECherubBoots : BEBoots {
	BECherubBoots() : base() {
		$this.Name               = 'Cherub Boots'
		$this.MapObjName         = 'cherubboots'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::Defense = 50
			[StatId]::MagicDefense = 35
			[StatId]::Speed = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Light and protective boots.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Female
	}
}
