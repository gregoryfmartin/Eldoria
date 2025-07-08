using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE WARLORDS HELM
#
###############################################################################

Class BEWarlordsHelm : BEHelmet {
	BEWarlordsHelm() : base() {
		$this.Name               = 'Warlord''s Helm'
		$this.MapObjName         = 'warlordshelm'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{
			[StatId]::Defense = 20
			[StatId]::MagicDefense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A formidable helm worn by military commanders, inspiring loyalty and fear.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
