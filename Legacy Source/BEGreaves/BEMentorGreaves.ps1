using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMENTORGREAVES
#
###############################################################################

Class BEMentorGreaves : BEGreaves {
	BEMentorGreaves() : base() {
		$this.Name               = 'Mentor Greaves'
		$this.MapObjName         = 'mentorgreaves'
		$this.PurchasePrice      = 380
		$this.SellPrice          = 190
		$this.TargetStats        = @{
			[StatId]::Defense = 13
			[StatId]::MagicDefense = 11
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves for guiding others.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
