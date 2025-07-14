using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECHAOSLORDSHELM
#
###############################################################################

Class BEChaosLordsHelm : BEHelmet {
	BEChaosLordsHelm() : base() {
		$this.Name               = 'Chaos Lord''s Helm'
		$this.MapObjName         = 'chaoslordshelm'
		$this.PurchasePrice      = 8500
		$this.SellPrice          = 4250
		$this.TargetStats        = @{
			[StatId]::Defense = 45
			[StatId]::MagicDefense = 75
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm of pure chaos, granting unpredictable and devastating power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
