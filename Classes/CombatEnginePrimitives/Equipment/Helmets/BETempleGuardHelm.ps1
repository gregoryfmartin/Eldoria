using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BETEMPLEGUARDHELM
#
###############################################################################

Class BETempleGuardHelm : BEHelmet {
	BETempleGuardHelm() : base() {
		$this.Name               = 'Temple Guard Helm'
		$this.MapObjName         = 'templeguardhelm'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::Defense = 12
			[StatId]::MagicDefense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sacred helm worn by temple guards, imbued with divine protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
