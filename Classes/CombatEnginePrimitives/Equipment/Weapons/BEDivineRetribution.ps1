using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE DEVINE RETRIBUTION
#
###############################################################################

Class BEDivineRetribution : BEWeapon {
	BEDivineRetribution() : base() {
		$this.Name          = 'Divine Retribution'
		$this.MapObjName    = 'divineretribution'
		$this.PurchasePrice = 7000
		$this.SellPrice     = 3500
		$this.TargetStats   = @{
			[StatId]::Attack      = 170
			[StatId]::MagicAttack = 95
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A mace that delivers divine punishment, smiting the wicked.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
