using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDREAMCATCHERSTIARA
#
###############################################################################

Class BEDreamCatchersTiara : BEHelmet {
	BEDreamCatchersTiara() : base() {
		$this.Name               = 'Dream Catcher''s Tiara'
		$this.MapObjName         = 'dreamcatcherstiara'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 11
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A mystical tiara that protects against nightmares and enhances lucid dreaming.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
