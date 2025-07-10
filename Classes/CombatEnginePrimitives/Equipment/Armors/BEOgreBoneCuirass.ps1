using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEOGREBONECUIRASS
#
###############################################################################

Class BEOgreBoneCuirass : BEArmor {
	BEOgreBoneCuirass() : base() {
		$this.Name               = 'Ogre Bone Cuirass'
		$this.MapObjName         = 'ogrebonecuirass'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{
			[StatId]::Defense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A heavy cuirass made from ogre bones, very intimidating.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
