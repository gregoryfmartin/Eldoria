using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BENURSESUNIFORM
#
###############################################################################

Class BENursesUniform : BEArmor {
	BENursesUniform() : base() {
		$this.Name               = 'Nurse''s Uniform'
		$this.MapObjName         = 'nursesuniform'
		$this.PurchasePrice      = 65
		$this.SellPrice          = 33
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A simple white uniform, surprisingly durable.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
