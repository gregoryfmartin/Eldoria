using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE LUNAR ECLIPSE HELM
#
###############################################################################

Class BELunarEclipseHelm : BEHelmet {
	BELunarEclipseHelm() : base() {
		$this.Name               = 'Lunar Eclipse Helm'
		$this.MapObjName         = 'lunareclipsehelm'
		$this.PurchasePrice      = 6500
		$this.SellPrice          = 3250
		$this.TargetStats        = @{
			[StatId]::Defense = 30
			[StatId]::MagicDefense = 35
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm shrouded in the darkness of a lunar eclipse, granting shadowy powers.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
