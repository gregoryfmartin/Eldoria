using namespace System
using namespace System.Collections
using namespace System.Collections.Generic
using namespace System.Management.Automation.Host


Enum QuestlineType {
    Core
    Side
    OneOff
    None
}

Class QuestStep {
    [Boolean]$Completed

    QuestStep() {
        Write-Host 'Entering QuestStep Default Constructor...'

        $this.Completed = $false # UNSET THIS FLAG BY DEFAULT; THE QUESTSTEP SHOULDN'T BE COMPLETED AT THIS POINT

        Write-Host 'Exiting QuestStep Default Constructor...'
    }

    [Void]Update() {} # THIS METHOD IS INTENDED TO BE VIRTUAL AT THIS POINT
}

Class QuestReward {
    [Boolean]$Given

    QuestReward() {
        Write-Host 'Entering QuestReward Default Constructor...'

        $this.Given = $false

        Write-Host 'Exiting QuestReward Default Constructor...'
    }

    [Void]Give() {
        Write-Host 'Entering QuestReward Give Method...'

        $this.Given = $true # AT A MINIMUM, THIS SHOULD SET THE GIVEN FLAG TO TRUE

        Write-Host 'Exiting QuestReward Give Method...'
    }
}

Class Quest {
    [Boolean]$Active
    [Boolean]$Completed
    [Boolean]$RewardsGiven
    [List[QuestStep]]$Steps
    [List[QuestReward]]$Rewards

    Quest() {
        Write-Host 'Entering Quest Default Constructor...'

        $this.Active       = $false
        $this.Completed    = $false
        $this.RewardsGiven = $false
        $this.Steps        = [List[QuestStep]]::new()
        $this.Rewards      = [List[QuestReward]]::new()

        Write-Host 'Exiting Quest Default Constructor...'
    }

    Quest(
        [List[QuestStep]]$Steps,
        [List[QuestReward]]$Rewards
    ) {
        Write-Host 'Entering Quest Secondary Constructor...'
        Write-Host "Value of Steps is $($Steps)"
        Write-Host "Value of Rewards is $($Rewards)"

        $this.Active       = $false
        $this.Completed    = $false
        $this.RewardsGiven = $false
        $this.Steps        = $Steps
        $this.Rewards      = $Rewards

        Write-Host 'Exiting Quest Secondary Constructor...'
    }

    Quest(
        [QuestStep[]]$Steps,
        [QuestReward[]]$Rewards
    ) {
        Write-Host 'Entering Quest Tertiary Constructor...'
        Write-Host "Value of Steps is $($Steps)"
        Write-Host "Value of Rewards is $($Rewards)"

        $this.Active       = $false
        $this.Completed    = $false
        $this.RewardsGiven = $false
        $this.Steps        = [List[QuestStep]]::new()
        $this.Rewards      = [List[QuestReward]]::new()

        Foreach($A in $Steps) {
            Write-Host "Adding $($A) to Steps..."
            $this.Steps.Add($A) | Out-Null
        }
        Foreach($A in $Rewards) {
            Write-Host "Adding $($A) to Rewards..."
            $this.Rewards.Add($A) | Out-Null
        }

        Write-Host 'Exiting Quest Tertiary Constructor...'
    }

    [Void]Update() {}
}

Class LinearQuest : Quest {
    [Int]$CurrentStep

    LinearQuest() : base() {
        Write-Host 'Entering LinearQuest Default Constructor...'
        
        $this.CurrentStep = 0

        Write-Host 'Exiting LinearQuest Default Constructor...'
    }

    LinearQuest(
        [List[QuestStep]]$Steps,
        [List[QuestReward]]$Rewards
    ) : base($Steps, $Rewards) {
        Write-Host 'Entering LinearQuest Secondary Constructor...'
        Write-Host "Value of Steps is $($Steps)"
        Write-Host "Value of Rewards is $($Rewards)"

        $this.CurrentStep = 0

        Write-Host 'Exiting LinearQuest Secondary Constructor...'
    }

    LinearQuest(
        [QuestStep[]]$Steps,
        [QuestReward[]]$Rewards
    ) : base($Steps, $Rewards) {
        Write-Host 'Entering LinearQuest Tertiary Constructor...'
        Write-Host "Value of Steps is $($Steps)"
        Write-Host "Value of Rewards is $($Rewards)"

        $this.CurrentStep = 0

        Write-Host 'Exiting LinearQuest Tertiary Constructor...'
    }

    [QuestStep]GetCurrentStep() {
        Write-Host 'Entering LinearQuest GetCurrentStep Method...'
        Write-Host "Returning $($this.Steps[$this.CurrentStep]) to the caller..."

        Return $this.Steps[$this.CurrentStep]
    }

    [Void]Update() {
        Write-Host 'Entering LinearQuest Update Method...'

        If($this.Active -EQ $true) { # IS THIS QUEST'S ACTIVE FLAG SET?
            Write-Host 'LinearQuest Active flag IS SET...'
            If($this.Completed -EQ $false) { # HAS THIS QUEST'S COMPLETE FLAG NOT YET BEEN SET?
                Write-Host 'LinearQuest Completed flag IS UNSET...'
                If($this.CurrentStep -LT $this.Steps.Count) { # IS THE CURRENT STEP COUNTER LESS THAN THE TOTAL NUMBER OF STEPS (INCLUSIVE)?
                    Write-Host 'LinearQuest CurrentStep is LESS THAN Steps.Count...'
                    Write-Host 'Calling the Current Step Update Method...'
                    $this.Steps[$this.CurrentStep].Update() # UPDATE THE CURRENT STEP (SETS THE STEP'S COMPLETED FLAG IF HEURISTICS ARE SATISFIED)

                    Write-Host 'Returning to LinearQuest Update Method...'
                    If($this.Steps[$this.CurrentStep].Completed -EQ $true) { # AFTER HAVING CALLED UPDATE, HAS THE STEP'S COMPLETED FLAG BEEN SET?
                        $this.CurrentStep++ # YES, INCREMENT THE CURRENTSTEP COUNTER
                    }
                } Else { # IF($THIS.CURRENTSTEP -LT $THIS.STEPS.COUNT)
                    # THIS IS A REALLY POOR MAN'S WAY OF CONCEDING THAT THE COMPLETION
                    # HAS BEEN MET, BUT GIVEN THAT THE CURRENTSTEP WOULDN'T INCREMENT
                    # UNLESS THE STEP COMPLETION FLAG HAD BEEN SET, IT SHOULD BE SANE
                    # TO ASSUME THAT ALL QUEST STEPS ARE COMPLETED BY THIS POINT.
                    $this.Completed = $true
                }
            } Else { # IF($THIS.COMPLETED -EQ $FALSE)
                If($this.RewardsGiven -EQ $false) { # HAS THE REWARDSGIVEN FLAG NOT YET BEEN SET?
                    # THE CODE HERE IS SIMILAR TO WHAT'S IN NONLINEAR QUEST.
                    # READ THAT FOR MORE DETAILS.
                    Foreach($A in $this.Rewards) { # LOOP THROUGH ALL THE ELEMENTS IN THE REWARDS CONTAINER
                        If($A.Given -EQ $false) { # HAS THIS ELEMENT'S GIVEN FLAG NOT YET BEEN SET?
                            $A.Give() # NO - EXECUTE THE ELEMENT'S GIVE METHOD (SETS THIS ELEMENT'S GIVEN FLAG)
                        }
                    }
                    $this.RewardsGiven = $true # SET THE REWARDSGIVEN FLAG
                    $this.Active       = $false # UNSET THE ACTIVE FLAG
                } # IF($THIS.REWARDSGIVEN -EQ $FALSE)
            } # IF($THIS.COMPLETED -EQ $FALSE)
        } # IF($THIS.ACTIVE -EQ $TRUE)
    } # END UPDATE METHOD DEFINITION
}

Class NonlinearQuest : Quest {
    NonlinearQuest() : base() {}

    NonlinearQuest(
        [List[QuestStep]]$Steps,
        [List[QuestReward]]$Rewards
    ) : base($Steps, $Rewards) {}

    NonlinearQuest(
        [QuestStep[]]$Steps,
        [QuestReward[]]$Rewards
    ) : base($Steps, $Rewards) {}

    [Void]Update() {
        If($this.Active -EQ $true) { # IS THIS QUEST'S ACTIVE FLAG SET?
            If($this.Completed -EQ $false) { # HAS THIS QUEST'S COMPLETE FLAG NOT YET BEEN SET?
                [Int]$A = 0 # INITIALIZE A "TRUE" COUNTER

                Foreach($Q in $this.Steps) {
                    If($Q.Completed -EQ $false) { # HAS THE STEP'S COMPLETED FLAG NOT YET BEEN SET?
                        $Q.Update() # IF NOT, CALL THE STEP'S UPDATE METHOD
                    } Else {
                        $A++ # THE STEP'S COMPLETED FLAG HAS BEEN SET, INCREMENT THE "TRUE" COUNTER
                    }
                }

                If($A -EQ $this.Steps.Count) { # DO THE NUMBER OF COMPLETED STEPS EQUAL THE NUMBER OF STEPS IN THIS QUEST?
                    $this.Completed = $true # YES, SET THE QUEST'S COMPLETED FLAG
                }
            } Else { # IF($THIS.COMPLETED -EQ $FALSE)
                If($this.RewardsGiven -EQ $false) { # HAS THE REWARDSGIVEN FLAG NOT YET BEEN SET?
                    # IT'S POSSIBLE THERE AREN'T ANY REWARDS FOR A QUEST... I SUPPOSE.
                    # REGARDLESS, IT'S BETTER TO TRY AND CATER FOR IT THAN OTHERWISE.
                    Foreach($A in $this.Rewards) { # LOOP THROUGH ALL THE ELEMENTS IN THE REWARDS CONTAINER
                        If($A.Given -EQ $false) { # HAS THIS ELEMENT'S GIVEN FLAG NOT YET BEEN SET?
                            $A.Give() # NO - EXECUTE THE ELEMENT'S GIVE METHOD (SETS THIS ELEMENT'S GIVEN FLAG)
                        }
                    }
                    $this.RewardsGiven = $true # SET THE REWARDSGIVEN FLAG

                    # THIS MAY OR MAY NOT BE THE BEST PLACE FOR THIS,
                    # BUT AT THIS POINT, THE QUEST COULD BE CONSIDERED INACTIVE
                    # SINCE THERE'S NOTHING LEFT TO GAIN FROM IT REMAINING SO.
                    # THE CATCH HERE IS THAT EVERY QUEST SHOULD HAVE ITS REWARDSGIVEN
                    # FLAG UNSET AT TIME OF CREATION SO THAT THIS GETS PARSED.
                    $this.Active = $false
                } # IF($THIS.REWARDSGIVEN -EQ $FALSE)
            } # IF($THIS.COMPLETED -EQ $FALSE)
        } # IF($THIS.ACTIVE -EQ $TRUE)
    } # END UPDATE METHOD DEFINITION
}

Class Questline {
    [Int]$CurrentQuest
    [Boolean]$Active
    [Boolean]$Completed
    [Boolean]$RewardsGiven
    [List[Quest]]$Quests
    [List[QuestReward]]$Rewards
    [QuestlineType]$Type

    Questline() {
        Write-Host 'Entering Questline Default Constructor...'

        $this.CurrentQuest = 0
        $this.Active       = $false
        $this.Completed    = $false
        $this.RewardsGiven = $false
        $this.Quests       = [List[Quest]]::new()
        $this.Rewards      = [List[QuestReward]]::new()
        $this.Type         = [QuestlineType]::None

        Write-Host 'Exiting Questline Default Constructor...'
    }

    Questline(
        [List[Quest]]$Quests,
        [List[QuestReward]]$Rewards
    ) {
        Write-Host 'Entering Questline Secondary Constructor...'
        Write-Host "Value of Quests is $($Quests)"
        Write-Host "Value of Rewards is $($Rewards)"

        $this.CurrentQuest = 0
        $this.Active       = $false
        $this.Completed    = $false
        $this.RewardsGiven = $false
        $this.Quests       = $Quests
        $this.Rewards      = $Rewards
        $this.Type         = [QuestlineType]::None

        Write-Host 'Exiting Questline Secondary Constructor...'
    }

    Questline(
        [Quest[]]$Quests,
        [QuestReward[]]$Rewards
    ) {
        Write-Host 'Exiting Questline Tertiary Constructor...'
        Write-Host "Value of Quests is $($Quests)"
        Write-Host "Value of Rewards is $($Rewards)"

        $this.CurrentQuest = 0
        $this.Active       = $false
        $this.Completed    = $false
        $this.RewardsGiven = $false
        $this.Quests       = [List[Quest]]::new()
        $this.Rewards      = [List[QuestReward]]::new()
        $this.Type         = [QuestlineType]::None


        Foreach($A in $Quests) {
            Write-Host "Adding $($A) to Quests..."
            $this.Quests.Add($A) | Out-Null
        }
        Foreach($A in $Rewards) {
            Write-Host "Adding $($A) to Rewards..."
            $this.Rewards.Add($A) | Out-Null
        }

        Write-Host 'Exiting Questline Tertiary Constructor...'
    }

    [Quest]GetCurrentQuest() {
        Write-Host 'Entering GetCurrentQuest Method...'
        Write-Host "Returning the Quest $($this.Quests[$this.CurrentQuest])"

        Return $this.Quests[$this.CurrentQuest]
    }

    [Void]Update() {
        Write-Host 'Entering Update Method...'

        # THE CODE HERE IS GOING TO LOOK AWFULLY SIMILAR TO THE CODE IN THE UPDATE
        # METHOD IN THE LINEARQUEST CLASS. WE'RE TAKING THE D OUT OF DRY BAYBEE!
        # FOR FURTHER DETAILS ON THIS BLOCK, YOU SHOULD PROBABLY LOOK AT THE
        # UPDATE METHOD IN THE QUEST CLASS. I'LL REPEAT MYSELF IN LOGIC, NOT IN
        # COMMENTS; I DO HAVE *SOME* STANDARDS.
        If($this.Active -EQ $true) { # IS THIS QUESTLINE'S ACTIVE FLAG SET?
            Write-Host 'Questline is ACTIVE...'
            If($this.Completed -EQ $false) { # HAS THIS QUESTLINE'S COMPLETE FLAG NOT YET BEEN SET?
                Write-Host 'Questline IS NOT COMPLETED...'
                If($this.CurrentQuest -LT $this.Quests.Count) { # IS THE CURRENT QUEST COUNTER LESS THAN THE TOTAL NUMBER OF QUESTS (INCLUSIVE)?
                    Write-Host 'Questline CurrentQuest is LESS THAN Quests.Count...'
                    Write-Host 'Calling current Quest''s Update Method...'
                    $this.Quests[$this.CurrentQuest].Update() # UPDATE THE CURRENT QUEST (SETS THE QUEST'S COMPLETED FLAG IF HEURISTICS ARE SATISFIED)

                    Write-Host 'Returned to Questline Update...'
                    If($this.Quests[$this.CurrentQuest].Completed -EQ $true) { # AFTER HAVING CALLED UPDATE, HAS THE QUEST'S COMPLETED FLAG BEEN SET?
                        Write-Host 'CurrentQuest is COMPLETED... Incrementing the CurrentQuest Counter...'
                        $this.CurrentQuest++ # YES, INCREMENT THE CURRENTQUEST COUNTER
                    }
                } Else { # IF($THIS.CURRENTQUEST -LT $THIS.QUESTS.COUNT)
                    Write-Host 'Questline CurrentQuest is EQUAL TO OR GREATER THAN Quests.Count... Setting the Completed flag...'
                    # THIS IS A REALLY POOR MAN'S WAY OF CONCEDING THAT THE COMPLETION
                    # HAS BEEN MET, BUT GIVEN THAT THE CURRENTSTEP WOULDN'T INCREMENT
                    # UNLESS THE STEP COMPLETION FLAG HAD BEEN SET, IT SHOULD BE SANE
                    # TO ASSUME THAT ALL QUEST STEPS ARE COMPLETED BY THIS POINT.
                    $this.Completed = $true
                }
            } Else { # IF($THIS.COMPLETED -EQ $FALSE)
                Write-Host 'Questline IS COMPLETED...'
                If($this.RewardsGiven -EQ $false) { # HAS THE REWARDSGIVEN FLAG NOT YET BEEN SET?
                    Write-Host 'Questline RewardsGiven is FALSE... Issuing Rewards...'
                    Foreach($A in $this.Rewards) { # LOOP THROUGH ALL THE ELEMENTS IN THE REWARDS CONTAINER
                        Write-Host "Current Reward: $($A)"
                        If($A.Given -EQ $false) { # HAS THIS ELEMENT'S GIVEN FLAG NOT YET BEEN SET?
                            Write-Host 'Current Reward''s Given flag is unset... Calling its Give Method...'
                            $A.Give() # NO - EXECUTE THE ELEMENT'S GIVE METHOD (SETS THIS ELEMENT'S GIVEN FLAG)
                            Write-Host 'Return to Questline Update...'
                        }
                    }

                    Write-Host 'Setting Questline RewardsGiven flag and unsetting Active flag...'
                    $this.RewardsGiven = $true # SET THE REWARDSGIVEN FLAG
                    $this.Active       = $false # UNSET THE ACTIVE FLAG
                } # IF($THIS.REWARDSGIVEN -EQ $FALSE)
            } # IF($THIS.COMPLETED -EQ $FALSE)
        } # IF($THIS.ACTIVE -EQ $TRUE)

        Write-Host 'Exiting Update Method...'
    } # END UPDATE METHOD DEFINITION
}

Class QuestManager {
    [List[Questline]]$Questlines

    QuestManager() {
        Write-Host 'Entering QuestManager Default Constructor...'

        $this.Questlines = [List[Questline]]::new()

        Write-Host 'Exiting QuestManager Default Constructor...'
    }

    QuestManager(
        [List[Questline]]$Questlines
    ) {
        Write-Host 'Entering QuestManager Secondary Constructor...'
        Write-Host "Questlines parameter is $($Questlines)"

        $this.Questlines = $Questlines

        Write-Host 'Exiting QuestManager Secondary Constructor...'
    }

    QuestManager(
        [Questline[]]$Questlines
    ) {
        Write-Host 'Entering QuestManager Tertiary Constructor...'
        Write-Host "Questlines parameter is $($Questlines)"

        $this.Questlines = [List[Questline]]::new()

        Foreach($Q in $Questlines) {
            Write-Host "Adding $($Q) to Questlines..."
            $this.Questlines.Add($Q) | Out-Null
        }

        Write-Host 'Exiting QuestManager Tertiary Constructor...'
    }
}





###############################################################################
#
# TESTING AREA
#
###############################################################################
Write-Host 'Creating a new QuestManager...'
[QuestManager]$TheQuestManager = [QuestManager]::new()

