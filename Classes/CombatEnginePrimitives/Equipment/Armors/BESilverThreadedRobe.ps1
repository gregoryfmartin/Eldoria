using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESILVERTHREADEDROBE
#
###############################################################################

Class BESilverThreadedRobe : BEArmor {
	BESilverThreadedRobe() : base() {
		$this.Name               = 'Silver-Threaded Robe'
		$this.MapObjName         = 'silverthreadedrobe'
		$this.PurchasePrice      = 880
		$this.SellPrice          = 440
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe intricately woven with silver threads, enhances defense against dark magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
