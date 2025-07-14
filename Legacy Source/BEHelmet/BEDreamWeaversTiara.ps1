using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDREAMWEAVERSTIARA
#
###############################################################################

Class BEDreamWeaversTiara : BEHelmet {
	BEDreamWeaversTiara() : base() {
		$this.Name               = 'Dream Weaver''s Tiara'
		$this.MapObjName         = 'dreamweaverstiara'
		$this.PurchasePrice      = 6500
		$this.SellPrice          = 3250
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 55
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A tiara that allows the wearer to weave dreams into reality.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
