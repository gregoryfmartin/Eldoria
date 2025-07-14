using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESIMPLEDRESS
#
###############################################################################

Class BESimpleDress : BEArmor {
	BESimpleDress() : base() {
		$this.Name               = 'Simple Dress'
		$this.MapObjName         = 'simpledress'
		$this.PurchasePrice      = 60
		$this.SellPrice          = 30
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A basic dress, comfortable for daily wear.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
