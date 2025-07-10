using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEVALKYRIESHELM
#
###############################################################################

Class BEValkyriesHelm : BEHelmet {
	BEValkyriesHelm() : base() {
		$this.Name               = 'Valkyrie''s Helm'
		$this.MapObjName         = 'valkyrieshelm'
		$this.PurchasePrice      = 1900
		$this.SellPrice          = 950
		$this.TargetStats        = @{
			[StatId]::Defense = 17
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A winged helm worn by valkyries, granting them courage and strength.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
