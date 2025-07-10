using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECHRONOSBLADE
#
###############################################################################

Class BEChronosBlade : BEWeapon {
	BEChronosBlade() : base() {
		$this.Name          = 'Chronos Blade'
		$this.MapObjName    = 'chronosblade'
		$this.PurchasePrice = 6500
		$this.SellPrice     = 3250
		$this.TargetStats   = @{
			[StatId]::Attack      = 158
			[StatId]::MagicAttack = 70
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A blade that can slightly alter the flow of time, granting extra attacks.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
