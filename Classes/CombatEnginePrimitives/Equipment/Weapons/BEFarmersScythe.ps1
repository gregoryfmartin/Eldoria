using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEFARMERSSCYTHE
#
###############################################################################

Class BEFarmersScythe : BEWeapon {
	BEFarmersScythe() : base() {
		$this.Name          = 'Farmer''s Scythe'
		$this.MapObjName    = 'farmersscythe'
		$this.PurchasePrice = 160
		$this.SellPrice     = 80
		$this.TargetStats   = @{
			[StatId]::Attack = 16
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A tool for harvesting crops, dangerous in combat.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
