using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECREATIONHELM
#
###############################################################################

Class BECreationHelm : BEHelmet {
	BECreationHelm() : base() {
		$this.Name               = 'Creation Helm'
		$this.MapObjName         = 'creationhelm'
		$this.PurchasePrice      = 12000
		$this.SellPrice          = 6000
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 100
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm that embodies pure creation, allowing for the manifestation of wonders.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
