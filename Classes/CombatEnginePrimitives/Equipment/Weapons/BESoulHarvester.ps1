using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE SOUL HARVESTER
#
###############################################################################

Class BESoulHarvester : BEWeapon {
	BESoulHarvester() : base() {
		$this.Name          = 'Soul Harvester'
		$this.MapObjName    = 'soulharvester'
		$this.PurchasePrice = 1100
		$this.SellPrice     = 550
		$this.TargetStats   = @{
			[StatId]::Attack      = 56
			[StatId]::MagicAttack = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A scythe said to reap the souls of the fallen, restoring vitality to the wielder.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
