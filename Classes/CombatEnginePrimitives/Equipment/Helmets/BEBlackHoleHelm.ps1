using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BLACK HOLE HELM
#
###############################################################################

Class BEBlackHoleHelm : BEHelmet {
	BEBlackHoleHelm() : base() {
		$this.Name               = 'Black Hole Helm'
		$this.MapObjName         = 'blackholehelm'
		$this.PurchasePrice      = 7000
		$this.SellPrice          = 3500
		$this.TargetStats        = @{
			[StatId]::Defense = 40
			[StatId]::MagicDefense = 40
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm that seems to absorb light, granting control over gravitational forces.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
