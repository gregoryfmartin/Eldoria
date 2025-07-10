using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESPECTRALBLADE
#
###############################################################################

Class BESpectralBlade : BEWeapon {
	BESpectralBlade() : base() {
		$this.Name          = 'Spectral Blade'
		$this.MapObjName    = 'spectralblade'
		$this.PurchasePrice = 5900
		$this.SellPrice     = 2950
		$this.TargetStats   = @{
			[StatId]::Attack      = 140
			[StatId]::MagicAttack = 60
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A blade that can pass through physical objects, harming spirits.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
