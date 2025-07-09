using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BARON'S HELMET
#
###############################################################################

Class BEBaronsHelmet : BEHelmet {
	BEBaronsHelmet() : base() {
		$this.Name               = 'Baron''s Helmet'
		$this.MapObjName         = 'baronshelmet'
		$this.PurchasePrice      = 400
		$this.SellPrice          = 200
		$this.TargetStats        = @{
			[StatId]::Defense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sturdy helmet worn by barons, providing protection in battle.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
