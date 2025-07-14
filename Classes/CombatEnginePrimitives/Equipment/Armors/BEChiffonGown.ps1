using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECHIFFONGOWN
#
###############################################################################

Class BEChiffonGown : BEArmor {
	BEChiffonGown() : base() {
		$this.Name               = 'Chiffon Gown'
		$this.MapObjName         = 'chiffongown'
		$this.PurchasePrice      = 50
		$this.SellPrice          = 25
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A delicate and sheer gown, provides no protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
