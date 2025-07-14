using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BENEBULAVEIL
#
###############################################################################

Class BENebulaVeil : BEHelmet {
	BENebulaVeil() : base() {
		$this.Name               = 'Nebula Veil'
		$this.MapObjName         = 'nebulaveil'
		$this.PurchasePrice      = 4500
		$this.SellPrice          = 2250
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 35
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A veil that shimmers with the colors of a nebula, concealing the wearer''s true form.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
