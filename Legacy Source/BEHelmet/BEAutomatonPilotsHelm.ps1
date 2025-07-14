using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEAUTOMATONPILOTSHELM
#
###############################################################################

Class BEAutomatonPilotsHelm : BEHelmet {
	BEAutomatonPilotsHelm() : base() {
		$this.Name               = 'Automaton Pilot''s Helm'
		$this.MapObjName         = 'automatonpilotshelm'
		$this.PurchasePrice      = 1900
		$this.SellPrice          = 950
		$this.TargetStats        = @{
			[StatId]::Defense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm for piloting large automatons, providing necessary controls.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
