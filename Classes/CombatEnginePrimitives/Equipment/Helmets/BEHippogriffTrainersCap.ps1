using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE HIPPOGRIFF TRAINER'S CAP
#
###############################################################################

Class BEHippogriffTrainersCap : BEHelmet {
	BEHippogriffTrainersCap() : base() {
		$this.Name               = 'Hippogriff Trainer''s Cap'
		$this.MapObjName         = 'hippogrifftrainerscap'
		$this.PurchasePrice      = 100
		$this.SellPrice          = 50
		$this.TargetStats        = @{
			[StatId]::Defense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A practical cap worn by hippogriff trainers, aiding in communication with the creatures.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
