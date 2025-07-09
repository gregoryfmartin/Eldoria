using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE DWARVEN HELMET
#
###############################################################################

Class BEDwarvenHelmet : BEHelmet {
	BEDwarvenHelmet() : base() {
		$this.Name               = 'Dwarven Helmet'
		$this.MapObjName         = 'dwarvenhelmet'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::Defense = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A finely crafted, heavy helmet made by master dwarven smiths.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
