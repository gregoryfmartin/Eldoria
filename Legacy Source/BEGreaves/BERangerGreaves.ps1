using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BERANGERGREAVES
#
###############################################################################

Class BERangerGreaves : BEGreaves {
	BERangerGreaves() : base() {
		$this.Name               = 'Ranger Greaves'
		$this.MapObjName         = 'rangergreaves'
		$this.PurchasePrice      = 380
		$this.SellPrice          = 190
		$this.TargetStats        = @{
			[StatId]::Defense = 16
			[StatId]::MagicDefense = 14
			[StatId]::Speed = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves suitable for wilderness survival.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}
