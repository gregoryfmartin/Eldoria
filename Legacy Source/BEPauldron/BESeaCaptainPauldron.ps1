using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESEACAPTAINPAULDRON
#
###############################################################################

Class BESeaCaptainPauldron : BEPauldron {
	BESeaCaptainPauldron() : base() {
		$this.Name               = 'Sea Captain Pauldron'
		$this.MapObjName         = 'seacaptainpauldron'
		$this.PurchasePrice      = 8800
		$this.SellPrice          = 4400
		$this.TargetStats        = @{
			[StatId]::Defense = 176
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Durable and water-resistant, for those who command the seas.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
