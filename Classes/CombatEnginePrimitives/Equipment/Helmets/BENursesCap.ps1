using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BENURSESCAP
#
###############################################################################

Class BENursesCap : BEHelmet {
	BENursesCap() : base() {
		$this.Name               = 'Nurse''s Cap'
		$this.MapObjName         = 'nursescap'
		$this.PurchasePrice      = 50
		$this.SellPrice          = 25
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A simple cap worn by nurses, symbolizing care and dedication.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
