using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# EQUIPMENTSLOT ENUMERATION
#
# DEFINES THE AVAILABLE EQUIPMENT SLOTS FOR A BATTLE ENTITY IN ELDORIA.
# EACH SLOT REPRESENTS A LOCATION ON THE CHARACTER WHERE AN ITEM CAN BE EQUIPPED.
# USED FOR INVENTORY MANAGEMENT, STAT CALCULATION, AND EQUIPMENT UI RENDERING.
#
# SLOTS:
#   - ARMOR    : MAIN BODY ARMOR
#   - BOOTS    : FOOTWEAR
#   - CAPE     : BACK SLOT FOR CAPES OR CLOAKS
#   - GAUNTLETS: HAND/ARM PROTECTION
#   - GREAVES  : LEG ARMOR
#   - HELMET   : HEADGEAR
#   - JEWELRYA : FIRST ACCESSORY SLOT (RINGS, AMULETS, ETC.)
#   - JEWELRYB : SECOND ACCESSORY SLOT
#   - PAULDRON : SHOULDER ARMOR
#   - WEAPON   : MAIN HAND WEAPON
#
###############################################################################

Enum EquipmentSlot {
    Armor
    Boots
    Cape
    Gauntlets
    Greaves
    Helmet
    JewelryA
    JewelryB
    Pauldron
    Weapon
}