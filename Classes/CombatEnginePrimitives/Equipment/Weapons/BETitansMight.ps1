using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE TITANS MIGHT
#
###############################################################################

Class BETitansMight : BEWeapon {
	BETitansMight() : base() {
		$this.Name          = 'Titan''s Might'
		$this.MapObjName    = 'titansmight'
		$this.PurchasePrice = 6800
		$this.SellPrice     = 3400
		$this.TargetStats   = @{
			[StatId]::Attack = 185
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A massive two-handed weapon, only usable by those with immense strength.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
