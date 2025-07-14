using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEORNATEPLATEARMOR
#
###############################################################################

Class BEOrnatePlateArmor : BEArmor {
	BEOrnatePlateArmor() : base() {
		$this.Name               = 'Ornate Plate Armor'
		$this.MapObjName         = 'ornateplatearmor'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
			[StatId]::Defense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Highly decorative plate armor, more for ceremonies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
