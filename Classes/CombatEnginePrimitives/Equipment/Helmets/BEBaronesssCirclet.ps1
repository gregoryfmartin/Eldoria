using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BARONESS'S CIRCLET
#
###############################################################################

Class BEBaronesssCirclet : BEHelmet {
	BEBaronesssCirclet() : base() {
		$this.Name               = 'Baroness''s Circlet'
		$this.MapObjName         = 'baronessscirclet'
		$this.PurchasePrice      = 350
		$this.SellPrice          = 175
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An elegant circlet worn by baronesses, suitable for court.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
