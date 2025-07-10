using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEELVENBOW
#
###############################################################################

Class BEElvenBow : BEWeapon {
	BEElvenBow() : base() {
		$this.Name          = 'Elven Bow'
		$this.MapObjName    = 'elvenbow'
		$this.PurchasePrice = 1200
		$this.SellPrice     = 600
		$this.TargetStats   = @{
			[StatId]::Attack = 62
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A gracefully crafted bow, known for its incredible accuracy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
