using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEKUNOICHIPAULDRON
#
###############################################################################

Class BEKunoichiPauldron : BEPauldron {
	BEKunoichiPauldron() : base() {
		$this.Name               = 'Kunoichi Pauldron'
		$this.MapObjName         = 'kunoichipauldron'
		$this.PurchasePrice      = 9350
		$this.SellPrice          = 4675
		$this.TargetStats        = @{
			[StatId]::Defense = 187
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Allows for incredibly agile and precise movements in combat.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Female
	}
}
