using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE RUSTY KNIFE
#
###############################################################################

Class BERustyKnife : BEWeapon {
	BERustyKnife() : base() {
		$this.Name          = 'Rusty Knife'
		$this.MapObjName    = 'rustyknife'
		$this.PurchasePrice = 30
		$this.SellPrice     = 15
		$this.TargetStats   = @{
			[StatId]::Attack = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A corroded and dull knife.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
