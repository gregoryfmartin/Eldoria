using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE COCKATRICE PLUME HELM
#
###############################################################################

Class BECockatricePlumeHelm : BEHelmet {
	BECockatricePlumeHelm() : base() {
		$this.Name               = 'Cockatrice Plume Helm'
		$this.MapObjName         = 'cockatriceplumehelm'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Defense = 9
			[StatId]::MagicDefense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm adorned with cockatrice plumes, offering minor protection against petrification.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
