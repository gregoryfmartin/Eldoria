using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMENTORBOOTS
#
###############################################################################

Class BEMentorBoots : BEBoots {
	BEMentorBoots() : base() {
		$this.Name               = 'Mentor Boots'
		$this.MapObjName         = 'mentorboots'
		$this.PurchasePrice      = 350
		$this.SellPrice          = 175
		$this.TargetStats        = @{
			[StatId]::Defense = 12
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for guiding others.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
