using namespace System
using namespace System.Collections
using namespace System.Collections.Generic
using namespace System.Management.Automation.Host

Set-StrictMode -Version Latest

Class QuestStep {
    [Boolean]$Completed

    QuestStep() {
        Write-Host 'Entered QuestStep Default Constructor...'

        $this.Completed = $false # UNSET THIS FLAG BY DEFAULT; THE QUESTSTEP SHOULDN'T BE COMPLETED AT THIS POINT

        # FOR TESTING PURPOSES ONLY!!!
        $this.Completed = $true

        Write-Host 'Exiting QuestStep Default Constructor...'
    }

    [Void]Update() {
        Write-Warning 'Entered QuestStep Base Update Method!!!'
        Write-Warning 'Exiting QuestStep Base Update Method!!!'
    } # THIS METHOD IS INTENDED TO BE VIRTUAL AT THIS POINT
}

Class QuestReward {
    [Boolean]$Given

    QuestReward() {
        Write-Host 'Entered QuestReward Default Constructor...'

        $this.Given = $false

        Write-Host 'Exited QuestReward Default Constructor...'
    }

    [Void]Give() {
        Write-Host 'Entered QuestReward Give Method...'

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

    [Void]Update() {
        Write-Warning 'Entered Quest Base Update Method!!!'
        Write-Warning 'Exiting Quest Base Update Method!!!'
    }
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
            Write-Host 'The Active flag is SET...'

            If($this.Completed -EQ $false) { # HAS THIS QUEST'S COMPLETE FLAG NOT YET BEEN SET?
                Write-Host 'The Completed flag is UNSET...'

                If($this.CurrentStep -LT $this.Steps.Count) { # IS THE CURRENT STEP COUNTER LESS THAN THE TOTAL NUMBER OF STEPS (INCLUSIVE)?
                    Write-Host 'CurrentStep is LESS THAN Steps.Count...'

                    Write-Host 'Calling the Current Step''s Update Method...'
                    $this.Steps[$this.CurrentStep].Update() # UPDATE THE CURRENT STEP (SETS THE STEP'S COMPLETED FLAG IF HEURISTICS ARE SATISFIED)
                    Write-Host 'Returned from the Current Steps''s Update Method...'

                    If($this.Steps[$this.CurrentStep].Completed -EQ $true) { # AFTER HAVING CALLED UPDATE, HAS THE STEP'S COMPLETED FLAG BEEN SET?
                        Write-Host 'The Current Step''s Completed flag is SET...'
                        Write-Host 'Incrementing the CurrentStep counter...'

                        $this.CurrentStep++ # YES, INCREMENT THE CURRENTSTEP COUNTER
                    }
                }

                If($this.CurrentStep -GE $this.Steps.Count) { # IF($THIS.CURRENTSTEP -LT $THIS.STEPS.COUNT)
                    Write-Host 'CurrentStep is GREATER THAN OR EQUAL TO Steps.Count...'
                    Write-Warning 'Evidently, all QuestSteps are complete...'
                    Write-Host 'Setting the LinearQuest''s Completed flag to true...'

                    # THIS IS A REALLY POOR MAN'S WAY OF CONCEDING THAT THE COMPLETION
                    # HAS BEEN MET, BUT GIVEN THAT THE CURRENTSTEP WOULDN'T INCREMENT
                    # UNLESS THE STEP COMPLETION FLAG HAD BEEN SET, IT SHOULD BE SANE
                    # TO ASSUME THAT ALL QUEST STEPS ARE COMPLETED BY THIS POINT.
                    $this.Completed = $true
                }
            }
            
            If($this.Completed -EQ $true) { # IF($THIS.COMPLETED -EQ $FALSE)
                Write-Host 'The Completed flag is SET...'

                If($this.RewardsGiven -EQ $false) { # HAS THE REWARDSGIVEN FLAG NOT YET BEEN SET?
                    Write-Host 'The RewardsGiven flag is UNSET...'
                    Write-Warning 'Issuing Rewards to the Player...'

                    # THE CODE HERE IS SIMILAR TO WHAT'S IN NONLINEAR QUEST.
                    # READ THAT FOR MORE DETAILS.
                    Foreach($R in $this.Rewards) { # LOOP THROUGH ALL THE ELEMENTS IN THE REWARDS CONTAINER
                        If($R.Given -EQ $false) { # HAS THIS ELEMENT'S GIVEN FLAG NOT YET BEEN SET?
                            Write-Host 'Current Reward''s Given flag is UNSET...'
                            Write-Host 'Calling Give Method...'

                            $R.Give() # NO - EXECUTE THE ELEMENT'S GIVE METHOD (SETS THIS ELEMENT'S GIVEN FLAG)

                            Write-Host 'Returned from Give Method...'
                        }
                    }

                    Write-Host 'Setting RewardsGiven flag...'
                    $this.RewardsGiven = $true # SET THE REWARDSGIVEN FLAG

                    Write-Host 'Unsetting Active flag...'
                    $this.Active       = $false # UNSET THE ACTIVE FLAG
                } # IF($THIS.REWARDSGIVEN -EQ $FALSE)
            } # IF($THIS.COMPLETED -EQ $FALSE)
        } # IF($THIS.ACTIVE -EQ $TRUE)

        Write-Host 'Exiting LinearQuests'' Update Method...'
    } # END UPDATE METHOD DEFINITION
}

Class NonlinearQuest : Quest {
    NonlinearQuest() : base() {
        Write-Host 'Entering NonlinearQuest Default Constructor...'
        Write-Host 'Exiting NonlinearQuest Default Constructor...'
    }

    NonlinearQuest(
        [List[QuestStep]]$Steps,
        [List[QuestReward]]$Rewards
    ) : base($Steps, $Rewards) {
        Write-Host 'Entering NonlinearQuest Secondary Constructor...'
        Write-Host "Value of Steps is $($Steps)"
        Write-Host "Value of Rewards is $($Rewards)"
        Write-Host 'Exiting NonlinearQuest Secondary Constructor...'
    }

    NonlinearQuest(
        [QuestStep[]]$Steps,
        [QuestReward[]]$Rewards
    ) : base($Steps, $Rewards) {
        Write-Host 'Entering NonlinearQuest Tertiary Constructor...'
        Write-Host "Value of Steps is $($Steps)"
        Write-Host "Value of Rewards is $($Rewards)"
        Write-Host 'Exiting NonlinearQuests Tertiary Constructor...'
    }

    [Void]Update() {
        Write-Host 'Entering NonlinearQuest Update Method...'

        If($this.Active -EQ $true) { # IS THIS QUEST'S ACTIVE FLAG SET?
            Write-Host 'The Active flag is SET...'

            If($this.Completed -EQ $false) { # HAS THIS QUEST'S COMPLETE FLAG NOT YET BEEN SET?
                Write-Host 'The Completed flag is UNSET...'
                [Int]$A = 0 # INITIALIZE A "TRUE" COUNTER

                Write-Host 'Looping through all the Steps...'
                Foreach($Q in $this.Steps) {
                    If($Q.Completed -EQ $false) { # HAS THE STEP'S COMPLETED FLAG NOT YET BEEN SET?
                        Write-Host 'Quests'' Completed flag is UNSET... calling Update Method...'
                        $Q.Update() # IF NOT, CALL THE STEP'S UPDATE METHOD
                        Write-Host 'Returned from Quests'' Update Method...'
                    } Else {
                        Write-Host 'Quests'' Completed flag is SET... Incrementing the counter'
                        $A++ # THE STEP'S COMPLETED FLAG HAS BEEN SET, INCREMENT THE "TRUE" COUNTER
                    }
                }

                If($A -EQ $this.Steps.Count) { # DO THE NUMBER OF COMPLETED STEPS EQUAL THE NUMBER OF STEPS IN THIS QUEST?
                    Write-Host 'The Counter is EQUAL TO Steps.Count...'
                    Write-Host 'Setting the Completed flag...'

                    $this.Completed = $true # YES, SET THE QUEST'S COMPLETED FLAG
                }
            }
            
            If($this.Completed -EQ $true) { # IF($THIS.COMPLETED -EQ $FALSE)
                Write-Host 'The Completed flag is SET...'

                If($this.RewardsGiven -EQ $false) { # HAS THE REWARDSGIVEN FLAG NOT YET BEEN SET?
                    Write-Host 'The RewardsGiven flag is UNSET...'
                    Write-Warning 'Issuing Rewards to the Player...'

                    # IT'S POSSIBLE THERE AREN'T ANY REWARDS FOR A QUEST... I SUPPOSE.
                    # REGARDLESS, IT'S BETTER TO TRY AND CATER FOR IT THAN OTHERWISE.
                    Foreach($R in $this.Rewards) { # LOOP THROUGH ALL THE ELEMENTS IN THE REWARDS CONTAINER
                        If($R.Given -EQ $false) { # HAS THIS ELEMENT'S GIVEN FLAG NOT YET BEEN SET?
                            Write-Host 'Current Reward''s Given flag is UNSET...'
                            Write-Host 'Calling Give Method...'

                            $R.Give() # NO - EXECUTE THE ELEMENT'S GIVE METHOD (SETS THIS ELEMENT'S GIVEN FLAG)

                            Write-Host 'Returned from Give Method...'
                        }
                    }

                    Write-Host 'Setting RewardsGiven flag...'
                    $this.RewardsGiven = $true # SET THE REWARDSGIVEN FLAG

                    # THIS MAY OR MAY NOT BE THE BEST PLACE FOR THIS,
                    # BUT AT THIS POINT, THE QUEST COULD BE CONSIDERED INACTIVE
                    # SINCE THERE'S NOTHING LEFT TO GAIN FROM IT REMAINING SO.
                    # THE CATCH HERE IS THAT EVERY QUEST SHOULD HAVE ITS REWARDSGIVEN
                    # FLAG UNSET AT TIME OF CREATION SO THAT THIS GETS PARSED.
                    Write-Host 'Unsetting Active flag...'
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

    Questline() {
        # THIS CTOR MAY NOT BE ABLE TO BE USED!
        # IF A QUESTLINE IS CREATED FROM A SPLAT, THIS CTOR IS USED. THE ISSUE HERE IS THAT THE FIRST QUEST CAN'T BE SET AS ACTIVE AT THIS TIME
        # SINCE IT DOESN'T ACTUALLY EXIST IN THE LISTING AT THE TIME THIS CTOR IS CALLED, SO IT WOULD RESULT IN AN EXCEPTION.

        Write-Host 'Entering Questline Default Constructor...'

        $this.CurrentQuest = 0
        $this.Active       = $false
        $this.Completed    = $false
        $this.RewardsGiven = $false
        $this.Quests       = [List[Quest]]::new()
        $this.Rewards      = [List[QuestReward]]::new()

        Write-Host 'Exiting Questline Default Constructor...'
    }

    Questline(
        [List[Quest]]$Quests,
        [List[QuestReward]]$Rewards,
        [Boolean]$Active = $false
    ) {
        Write-Host 'Entering Questline Secondary Constructor...'
        Write-Host "Value of Quests is $($Quests)"
        Write-Host "Value of Rewards is $($Rewards)"

        $this.CurrentQuest = 0
        $this.Active       = $Active
        $this.Completed    = $false
        $this.RewardsGiven = $false
        $this.Quests       = [List[Quest]]::new($Quests)
        $this.Rewards      = [List[QuestReward]]::new($Rewards)

        $this.Quests[$this.CurrentQuest].Active = $true

        Write-Host 'Exiting Questline Secondary Constructor...'
    }

    Questline(
        [Quest[]]$Quests,
        [QuestReward[]]$Rewards,
        [Boolean]$Active = $false
    ) {
        Write-Host 'Entering Questline Tertiary Constructor...'
        Write-Host "Value of Quests is $($Quests)"
        Write-Host "Value of Rewards is $($Rewards)"

        $this.CurrentQuest = 0
        $this.Active       = $Active
        $this.Completed    = $false
        $this.RewardsGiven = $false
        $this.Quests       = [List[Quest]]::new()
        $this.Rewards      = [List[QuestReward]]::new()

        $this.Quests[$this.CurrentQuest].Active = $true

        Write-Host 'Exiting Questline Tertiary Constructor...'

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
        Write-Host 'Entering Questline GetCurrentQuest Method...'
        Write-Host "Returning $($this.Quests[$this.CurrentQuest]) to the caller..."

        Return $this.Quests[$this.CurrentQuest]
    }

    [Void]Update() {
        Write-Host 'Entering Questline Update Method...'

        # THE CODE HERE IS GOING TO LOOK AWFULLY SIMILAR TO THE CODE IN THE UPDATE
        # METHOD IN THE LINEARQUEST CLASS. WE'RE TAKING THE D OUT OF DRY BAYBEE!
        # FOR FURTHER DETAILS ON THIS BLOCK, YOU SHOULD PROBABLY LOOK AT THE
        # UPDATE METHOD IN THE QUEST CLASS. I'LL REPEAT MYSELF IN LOGIC, NOT IN
        # COMMENTS; I DO HAVE *SOME* STANDARDS.
        If($this.Active -EQ $true) { # IS THIS QUESTLINE'S ACTIVE FLAG SET?
            Write-Host 'Active flag is SET...'

            If($this.Completed -EQ $false) { # HAS THIS QUESTLINE'S COMPLETE FLAG NOT YET BEEN SET?
                Write-Host 'Completed flag is UNSET...'

                If($this.CurrentQuest -LT $this.Quests.Count) { # IS THE CURRENT QUEST COUNTER LESS THAN THE TOTAL NUMBER OF QUESTS (INCLUSIVE)?
                    Write-Host 'CurrentQuest is LESS THAN Quests.Count...'
                    Write-Host 'Calling CurrentQuest Update...'

                    $this.Quests[$this.CurrentQuest].Update() # UPDATE THE CURRENT QUEST (SETS THE QUEST'S COMPLETED FLAG IF HEURISTICS ARE SATISFIED)

                    Write-Host 'Returned from CurrentQuest Update...'

                    If($this.Quests[$this.CurrentQuest].Completed -EQ $true) { # AFTER HAVING CALLED UPDATE, HAS THE QUEST'S COMPLETED FLAG BEEN SET?
                        # CONFER THE REWARDS TO THE PLAYER (CALL UPDATE A SECOND TIME; THIS ALSO SETS THE QUESTS ACTIVE FLAG TO FALSE)
                        # Write-Host 'Quest is complete; calling its Update method again to confer rewards...'
                        # $this.Quests[$this.CurrentQuest].Update()

                        Write-Host 'CurrentQuests'' Completed flag is SET...'
                        Write-Host 'Increment the CurrentQuest counter...'
                        $this.CurrentQuest++ # YES, INCREMENT THE CURRENTQUEST COUNTER

                        If($this.CurrentQuest -LT $this.Quests.Count) {
                            $this.Quests[$this.CurrentQuest].Active = $true
                        }
                    }
                }

                # THERE'S A VERY SPECIFIC REASON FOR NOT USING AN ELSE FROM THE PREVIOUS CONDITIONAL; WASITNG CALL CYCLES!
                If($this.CurrentQuest -GE $this.Quests.Count) { # IF($THIS.CURRENTQUEST -LT $THIS.QUESTS.COUNT)
                    Write-Host 'CurrentQuest is LESS THAN Quests.Count...'
                    Write-Host 'Setting the Completed flag...'
                    # THIS IS A REALLY POOR MAN'S WAY OF CONCEDING THAT THE COMPLETION
                    # HAS BEEN MET, BUT GIVEN THAT THE CURRENTSTEP WOULDN'T INCREMENT
                    # UNLESS THE STEP COMPLETION FLAG HAD BEEN SET, IT SHOULD BE SANE
                    # TO ASSUME THAT ALL QUEST STEPS ARE COMPLETED BY THIS POINT.
                    $this.Completed = $true
                }
            }

            # THERE'S A VERY SPECIFIC REASON FOR NOT USING AN ELSE FROM THE PREVIOUS CONDITIONAL; WASITING CALL CYCLES!
            If($this.Completed -EQ $true) { # IF($THIS.COMPLETED -EQ $FALSE)
                Write-Host 'Completed flag is SET...'
                If($this.RewardsGiven -EQ $false) { # HAS THE REWARDSGIVEN FLAG NOT YET BEEN SET?
                    Write-Host 'RewardsGiven flag is UNSET...'
                    Foreach($A in $this.Rewards) { # LOOP THROUGH ALL THE ELEMENTS IN THE REWARDS CONTAINER
                        If($A.Given -EQ $false) { # HAS THIS ELEMENT'S GIVEN FLAG NOT YET BEEN SET?
                            Write-Host 'Current Reward''s Given flag is UNSET...'
                            Write-Host 'Calling Give Method...'
                            $A.Give() # NO - EXECUTE THE ELEMENT'S GIVE METHOD (SETS THIS ELEMENT'S GIVEN FLAG)

                            Write-Host 'Returning from Give Method...'
                        }
                    }

                    Write-Host 'Setting the RewardsGiven flag...'
                    $this.RewardsGiven = $true # SET THE REWARDSGIVEN FLAG

                    Write-Host 'Unsetting the Active flag...'
                    $this.Active       = $false # UNSET THE ACTIVE FLAG
                } # IF($THIS.REWARDSGIVEN -EQ $FALSE)
            } # IF($THIS.COMPLETED -EQ $FALSE)
        } # IF($THIS.ACTIVE -EQ $TRUE)

        Write-Host 'Exiting Questline Update Method...'
    } # END UPDATE METHOD DEFINITION
}

Class QAHasItem : QuestStep {
    [String]$TargetItem

    QAHasItem() : base() {
        Write-Host 'Entered QAHasItem Default Constructor...'

        $this.TargetItem = ''
        
        # FOR TESTING PURPOSES ONLY!!!
        $this.Completed = $true

        Write-Host 'Exiting QAHasItem Default Constructor...'
    }

    QAHasItem(
        [String]$TargetItem
    ) : base() {
        Write-Host 'Entered QAHasItem Secondary Constructor...'
        Write-Host "TargetItem is $($TargetItem)"

        $this.TargetItem = $TargetItem

        Write-Host 'Exiting QAHasItem Secondary Constructor...'
    }

    [Void]Update() {
        Write-Host 'Entered QAHasItem Update Method...'

        $this.Completed = $true

        Write-Host 'Exiting QAHasItem Update Method...'
    }
}

Class QAQuestCompleted : QuestStep {
    [Quest]$TargetQuest

    QAQuestCompleted() : base() {
        Write-Host 'Entered QAQuestCompleted Default Constructor...'

        $this.TargetQuest = $null

        # FOR TESTING PURPOSES ONLY!
        $this.Completed = $true

        Write-Host 'Exiting QAQuestCompleted Default Constructor...'
    }

    QAQuestCompleted(
        [Quest]$TargetQuest
    ) : base() {
        Write-Host 'Entered QAQuestCompleted Secondary Constructor...'
        Write-Host "TargetQuest is $($TargetQuest)"

        $this.TargetQuest = $TargetQuest

        Write-Host 'Exiting QAQuestCompleted Secondary Constructor...'
    }

    [Void]Update() {
        Write-Host 'Entered QAQuestCompleted Update Method...'

        $this.Completed = $true

        Write-Host 'Exiting QAQuestCompleted Update Method...'
    }
}

Class QAPlayerHasGold : QuestStep {
    [Int]$GoldTarget

    QAPlayerHasGold() : base() {
        Write-Host 'Entered QAPlayerHasGold Default Constructor...'

        $this.GoldTarget = 0

        # FOR TESTING PURPOSES ONLY!
        $this.Completed = $true

        Write-Host 'Exited QAPlayerHasGold Default Constructor...'
    }

    QAPlayerHasGold(
        [Int]$GoldTarget
    ) : base() {
        Write-Host 'Entered QAPlayerHasGold Secondary Constructor...'
        Write-Host "GoldTarget is $($GoldTarget)"

        $this.GoldTarget = $GoldTarget

        Write-Host 'Exiting QAPlayerHasGold Secondary Constructor...'
    }

    [Void]Update() {
        Write-Host 'Entering QAPlayerHasGold Update Method...'

        $this.Completed = $true

        Write-Host 'Exiting QAPlayerHasGold Update Method...'
    }
}

Write-Host 'Creating a new Questline...'
[Questline]$SampleQuestline2 = [Questline]::new(
    @(
        [NonlinearQuest]@{
            Steps = @(
                [QAHasItem]::new(),
                [QAPlayerHasGold]::new(),
                [QAQuestCompleted]::new(),
                [QuestStep]::new(),
                [QuestStep]::new()
            )
            Rewards = @(
                [QuestReward]::new(),
                [QuestReward]::new(),
                [QuestReward]::new()
            )
        },
        [LinearQuest]@{
            Steps = @(
                [QAHasItem]::new(),
                [QAPlayerHasGold]::new(),
                [QAQuestCompleted]::new(),
                [QuestStep]::new(),
                [QuestStep]::new(),
                [QuestStep]::new(),
                [QuestStep]::new(),
                [QuestStep]::new(),
                [QuestStep]::new(),
                [QuestStep]::new(),
                [QuestStep]::new()
            )
            Rewards = @(
                [QuestReward]::new(),
                [QuestReward]::new(),
                [QuestReward]::new()
            )
        }
    ),
    @(
        [QuestReward]::new(),
        [QuestReward]::new(),
        [QuestReward]::new(),
        [QuestReward]::new(),
        [QuestReward]::new()
    ),
    $true
)

# [Questline]$SampleQuestline = [Questline]@{
#     Quests = @(
#         [NonlinearQuest]@{
#             Steps = @(
#                 [QAHasItem]::new(),
#                 [QAPlayerHasGold]::new(),
#                 [QAQuestCompleted]::new(),
#                 [QuestStep]::new(),
#                 [QuestStep]::new()
#             )
#             Rewards = @(
#                 [QuestReward]::new(),
#                 [QuestReward]::new(),
#                 [QuestReward]::new()
#             )
#         },
#         [LinearQuest]@{
#             Steps = @(
#                 [QAHasItem]::new(),
#                 [QAPlayerHasGold]::new(),
#                 [QAQuestCompleted]::new(),
#                 [QuestStep]::new(),
#                 [QuestStep]::new(),
#                 [QuestStep]::new(),
#                 [QuestStep]::new(),
#                 [QuestStep]::new(),
#                 [QuestStep]::new(),
#                 [QuestStep]::new(),
#                 [QuestStep]::new()
#             )
#             Rewards = @(
#                 [QuestReward]::new(),
#                 [QuestReward]::new(),
#                 [QuestReward]::new()
#             )
#         }
#     )
#     Rewards = @(
#         [QuestReward]::new(),
#         [QuestReward]::new(),
#         [QuestReward]::new(),
#         [QuestReward]::new(),
#         [QuestReward]::new()
#     )
#     Active = $true
# }

Write-Host 'Sample Questline Created...'
Write-Host ''
Write-Host ''
Write-Host 'Calling Questline Update Method...'
Write-Host ''
$SampleQuestline2.Update()
Write-Host ''
Write-Host ''
Write-Host 'Calling Questline Update Method Again...'
$SampleQuestline2.Update()
Write-Host ''
Write-Host 'Calling Questline Update Method Again...'
$SampleQuestline2.Update()
Write-Host ''
Write-Host 'Calling Questline Update Method Again...'
$SampleQuestline2.Update()
Write-Host ''
Write-Host 'Calling Questline Update Method Again...'
$SampleQuestline2.Update()
Write-Host ''
Write-Host 'Calling Questline Update Method Again...'
$SampleQuestline2.Update()
Write-Host ''
Write-Host 'Calling Questline Update Method Again...'
$SampleQuestline2.Update()
Write-Host ''
Write-Host 'Calling Questline Update Method Again...'
$SampleQuestline2.Update()
Write-Host ''
Write-Host 'Calling Questline Update Method Again...'
$SampleQuestline2.Update()
Write-Host ''
Write-Host 'Calling Questline Update Method Again...'
$SampleQuestline2.Update()
Write-Host ''
Write-Host 'Calling Questline Update Method Again...'
$SampleQuestline2.Update()
Write-Host ''
Write-Host 'Calling Questline Update Method Again...'
$SampleQuestline2.Update()
Write-Host ''

