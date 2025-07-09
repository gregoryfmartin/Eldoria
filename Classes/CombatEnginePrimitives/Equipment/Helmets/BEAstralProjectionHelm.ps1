using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE ASTRAL PROJECTION HELM
#
###############################################################################

Class BEAstralProjectionHelm : BEHelmet {
	BEAstralProjectionHelm() : base() {
		$this.Name               = 'Astral Projection Helm'
		$this.MapObjName         = 'astralprojectionhelm'
		$this.PurchasePrice      = 2600
		$this.SellPrice          = 1300
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 22
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm that aids in astral projection, allowing the wearer to explore beyond their body.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
