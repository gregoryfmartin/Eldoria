using namespace System

Set-StrictMode -Version Latest





###############################################################################
#
# PLAYER SETUP SCREEN STATES
#
# THE STATES THAT THE PLAYER SETUP SCREEN GOES THROUGH.
#
# NOTE: THIS GOES AWAY WITH THE STATE MACHINE IMPLEMENTATION.
#
###############################################################################

Enum PlayerSetupScreenStates {
    PlayerSetupSetup
    PlayerSetupNameEntry
    PlayerSetupGenderSelection
    PlayerSetupPointAllocate
    PlayerSetupAffinitySelect
    PlayerSetupProfileSelect
    PlayerSetupConfirmation
}
