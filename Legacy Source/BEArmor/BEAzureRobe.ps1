using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEAZUREROBE
#
###############################################################################

Class BEAzureRobe : BEArmor {
	BEAzureRobe() : base() {
		$this.Name               = 'Azure Robe'
		$this.MapObjName         = 'azurerobe'
		$this.PurchasePrice      = 1350
		$this.SellPrice          = 675
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 31
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A brilliant blue robe, often worn by powerful water mages.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
