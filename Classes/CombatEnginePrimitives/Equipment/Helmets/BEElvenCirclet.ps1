using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE ELVEN CIRCLET
#
###############################################################################

Class BEElvenCirclet : BEHelmet {
	BEElvenCirclet() : base() {
		$this.Name               = 'Elven Circlet'
		$this.MapObjName         = 'elvencirclet'
		$this.PurchasePrice      = 400
		$this.SellPrice          = 200
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An exquisitely crafted circlet worn by elves, enhancing their natural grace.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
