using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BENOMADICWARLORDPAULDRON
#
###############################################################################

Class BENomadicWarlordPauldron : BEPauldron {
	BENomadicWarlordPauldron() : base() {
		$this.Name               = 'Nomadic Warlord Pauldron'
		$this.MapObjName         = 'nomadicwarlordpauldron'
		$this.PurchasePrice      = 8500
		$this.SellPrice          = 4250
		$this.TargetStats        = @{
			[StatId]::Defense = 170
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Combines mobility with imposing presence, for fierce tribal leaders.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
