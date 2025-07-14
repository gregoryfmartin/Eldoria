using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESTARLIGHTHELM
#
###############################################################################

Class BEStarlightHelm : BEHelmet {
	BEStarlightHelm() : base() {
		$this.Name               = 'Starlight Helm'
		$this.MapObjName         = 'starlighthelm'
		$this.PurchasePrice      = 4200
		$this.SellPrice          = 2100
		$this.TargetStats        = @{
			[StatId]::Defense = 12
			[StatId]::MagicDefense = 32
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm that gathers starlight, empowering the wearer with celestial energy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
