using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE REALITY BENDER'S TIARA
#
###############################################################################

Class BERealityBendersTiara : BEHelmet {
	BERealityBendersTiara() : base() {
		$this.Name               = 'Reality Bender''s Tiara'
		$this.MapObjName         = 'realitybenderstiara'
		$this.PurchasePrice      = 6000
		$this.SellPrice          = 3000
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 38
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A tiara that allows the wearer to bend reality to their will, within limits.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
