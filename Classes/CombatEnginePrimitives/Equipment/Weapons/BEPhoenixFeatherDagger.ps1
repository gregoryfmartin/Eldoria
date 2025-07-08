using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE PHOENIX FEATHER DAGGER
#
###############################################################################

Class BEPhoenixFeatherDagger : BEWeapon {
	BEPhoenixFeatherDagger() : base() {
		$this.Name          = 'Phoenix Feather Dagger'
		$this.MapObjName    = 'phoenixfeatherdagger'
		$this.PurchasePrice = 3900
		$this.SellPrice     = 1950
		$this.TargetStats   = @{
			[StatId]::Attack      = 90
			[StatId]::MagicAttack = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dagger made with a phoenix feather, allowing revival once per battle.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
