using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBARDSTUNIC
#
###############################################################################

Class BEBardsTunic : BEArmor {
	BEBardsTunic() : base() {
		$this.Name               = 'Bard''s Tunic'
		$this.MapObjName         = 'bardstunic'
		$this.PurchasePrice      = 160
		$this.SellPrice          = 80
		$this.TargetStats        = @{
			[StatId]::Defense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A comfortable and stylish tunic for performers.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
