using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEHUNTINGKNIFE
#
###############################################################################

Class BEHuntingKnife : BEWeapon {
	BEHuntingKnife() : base() {
		$this.Name          = 'Hunting Knife'
		$this.MapObjName    = 'huntingknife'
		$this.PurchasePrice = 65
		$this.SellPrice     = 32
		$this.TargetStats   = @{
			[StatId]::Attack = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A versatile knife for hunting and survival.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
