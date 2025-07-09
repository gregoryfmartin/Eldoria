using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE OGRE'S CLUB HELM
#
###############################################################################

Class BEOgresClubHelm : BEHelmet {
	BEOgresClubHelm() : base() {
		$this.Name               = 'Ogre''s Club Helm'
		$this.MapObjName         = 'ogresclubhelm'
		$this.PurchasePrice      = 350
		$this.SellPrice          = 175
		$this.TargetStats        = @{
			[StatId]::Defense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A massive helm fashioned from an ogre''s club, offering blunt force protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
