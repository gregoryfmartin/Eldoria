using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPRIESTSMITRE
#
###############################################################################

Class BEPriestsMitre : BEHelmet {
	BEPriestsMitre() : base() {
		$this.Name               = 'Priest''s Mitre'
		$this.MapObjName         = 'priestsmitre'
		$this.PurchasePrice      = 180
		$this.SellPrice          = 90
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A ceremonial mitre worn by priests, enhancing divine blessings.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
