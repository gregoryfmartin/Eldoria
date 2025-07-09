using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE DUKE'S GREATHELM
#
###############################################################################

Class BEDukesGreathelm : BEHelmet {
	BEDukesGreathelm() : base() {
		$this.Name               = 'Duke''s Greathelm'
		$this.MapObjName         = 'dukesgreathelm'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::Defense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A grand greathelm worn by dukes, signifying their martial prowess.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
