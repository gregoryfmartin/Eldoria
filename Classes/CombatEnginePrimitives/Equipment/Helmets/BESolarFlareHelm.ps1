using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE SOLAR FLARE HELM
#
###############################################################################

Class BESolarFlareHelm : BEHelmet {
	BESolarFlareHelm() : base() {
		$this.Name               = 'Solar Flare Helm'
		$this.MapObjName         = 'solarflarehelm'
		$this.PurchasePrice      = 6500
		$this.SellPrice          = 3250
		$this.TargetStats        = @{
			[StatId]::Defense = 35
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm that bursts with solar energy, incinerating foes with light.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
