using namespace System

Set-StrictMode -Version Latest





###############################################################################
#
# CONTEXT BROADCASTER
#
# BROADCASTS CONTEXTS ON THE NIGHTLY NEWS. TOM BROKAW WOULD BE PROUD.
#
###############################################################################

Class ContextBroadcaster {
    ContextBroadcaster() {}

    [Void]Broadcast(
        [String]$EventName,
        [Object]$Sender,
        [Context]$Context
    ) {
        # TODO: DEVISE BAD ARGUMENT VALUE STRATEGIES

        $null = New-Event -SourceIdentifier $EventName -Sender $Sender -MessageData $Context
    }
}
