using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# ITEM REMOVAL STATUS
#
# SUCCESS
#    THE ITEM WAS SUCCESSFULLY REMOVED FROM THE ITEM INVENTORY.
#
# FAIL GENERAL
#    THE ITEM FAILED TO BE REMOVED FROM THE ITEM INVENTORY FOR AN UNSPECIFIC REASON.
#
# FAIL KEY ITEM
#    THE ITEM FAILED TO BE REMOVED FROM THE ITEM INVENTORY BECAUSE IT'S A KEY ITEM.
#
###############################################################################

Enum ItemRemovalStatus {
    Success
    FailGeneral
    FailKeyItem
}
