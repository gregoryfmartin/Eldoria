using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBALLGOWN
#
###############################################################################

Class BEBallGown : BEArmor {
	BEBallGown() : base() {
		$this.Name               = 'Ball Gown'
		$this.MapObjName         = 'ballgown'
		$this.PurchasePrice      = 400
		$this.SellPrice          = 200
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A magnificent gown, offers no protection but great charm.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
