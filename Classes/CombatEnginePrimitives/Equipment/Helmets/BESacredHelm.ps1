using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE SACRED HELM
#
###############################################################################

Class BESacredHelm : BEHelmet {
	BESacredHelm() : base() {
		$this.Name               = 'Sacred Helm'
		$this.MapObjName         = 'sacredhelm'
		$this.PurchasePrice      = 2700
		$this.SellPrice          = 1350
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm blessed by ancient deities, offering immense spiritual protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
