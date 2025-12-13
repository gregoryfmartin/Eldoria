using namespace System
using namespace System.Collections.Generic

Set-StrictMode -Version Latest

###############################################################################
#
# MESSAGE WINDOW
#
# THIS WINDOW DISPLAYS MESSAGES IN THE MAP NAVIGATION SCREEN.
#
###############################################################################

Class MessageWindow : WindowBase {
    Static [Int]$MessageHistoryARef = 0
    Static [Int]$MessageHistoryBRef = 1
    Static [Int]$MessageHistoryCRef = 2
    Static [Int]$WindowLTRow        = 24
    Static [Int]$WindowLTColumn     = 1
    Static [Int]$WindowRBRow        = 28
    Static [Int]$WindowRBColumn     = 80

    Static [String]$WindowTitle = 'Messages'

    Static [ATCoordinates]$MessageADrawCoordinates = [ATCoordinatesNone]::new()
    Static [ATCoordinates]$MessageBDrawCoordinates = [ATCoordinatesNone]::new()
    Static [ATCoordinates]$MessageCDrawCoordinates = [ATCoordinatesNone]::new()

    Static [ATString]$MessageWindowBlank = [ATStringNone]::new()

    [ATStringComposite[]]$MessageHistory

    [Boolean]$MessageADirty
    [Boolean]$MessageBDirty
    [Boolean]$MessageCDirty

    MessageWindow() : base() {
        $this.LeftTop     = [ATCoordinates]::new([MessageWindow]::WindowLTRow, [MessageWindow]::WindowLTColumn)
        $this.RightBottom = [ATCoordinates]::new([MessageWindow]::WindowRBRow, [MessageWindow]::WindowRBColumn)

        $this.UpdateDimensions()
        $this.SetupTitle([MessageWindow]::WindowTitle, [CCTextDefault24]::new())

        [MessageWindow]::MessageCDrawCoordinates = [ATCoordinates]@{
            Row    = ($this.RightBottom.Row - 1)
            Column = ($this.LeftTop.Column + 1)
        }
        [MessageWindow]::MessageBDrawCoordinates = [ATCoordinates]@{
            Row    = ([MessageWindow]::MessageCDrawCoordinates.Row - 1)
            Column = ($this.LeftTop.Column + 1)
        }
        [MessageWindow]::MessageADrawCoordinates = [ATCoordinates]@{
            Row    = ([MessageWindow]::MessageBDrawCoordinates.Row - 1)
            Column = ($this.LeftTop.Column + 1)
        }
        [MessageWindow]::MessageWindowBlank = [ATString]@{
            Prefix     = [ATStringPrefix]::new()
            UserData   = '                                                                             '
            UseATReset = $true
        }
        $this.MessageHistory = @(
            [ATStringComposite]::new(),
            [ATStringComposite]::new(),
            [ATStringComposite]::new()
        )
        $this.MessageHistory[[MessageWindow]::MessageHistoryARef].CompositeActual[0].Prefix.Coordinates = [MessageWindow]::MessageADrawCoordinates
        $this.MessageHistory[[MessageWindow]::MessageHistoryBRef].CompositeActual[0].Prefix.Coordinates = [MessageWindow]::MessageBDrawCoordinates
        $this.MessageHistory[[MessageWindow]::MessageHistoryCRef].CompositeActual[0].Prefix.Coordinates = [MessageWindow]::MessageCDrawCoordinates
    }

    [Void]Draw() {
        ([WindowBase]$this).Draw()

        If($this.MessageADirty -EQ $true) {
            [MessageWindow]::MessageWindowBlank.Prefix.Coordinates = [MessageWindow]::MessageADrawCoordinates
            Write-Host "$([MessageWindow]::MessageWindowBlank.ToAnsiControlSequenceString())$([MessageWindow]::MessageADrawCoordinates.ToAnsiControlSequenceString())$($this.MessageHistory[[MessageWindow]::MessageHistoryARef].ToAnsiControlSequenceString())"
            $this.MessageADirty = $false
        }
        If($this.MessageBDirty -EQ $true) {
            [MessageWindow]::MessageWindowBlank.Prefix.Coordinates = [MessageWindow]::MessageBDrawCoordinates
            Write-Host "$([MessageWindow]::MessageWindowBlank.ToAnsiControlSequenceString())$([MessageWindow]::MessageBDrawCoordinates.ToAnsiControlSequenceString())$($this.MessageHistory[[MessageWindow]::MessageHistoryBRef].ToAnsiControlSequenceString())"
            $this.MessageBDirty = $false
        }
        If($this.MessageCDirty -EQ $true) {
            [MessageWindow]::MessageWindowBlank.Prefix.Coordinates = [MessageWindow]::MessageCDrawCoordinates
            Write-Host "$([MessageWindow]::MessageWindowBlank.ToAnsiControlSequenceString())$([MessageWindow]::MessageCDrawCoordinates.ToAnsiControlSequenceString())$($this.MessageHistory[[MessageWindow]::MessageHistoryCRef].ToAnsiControlSequenceString())"
            $this.MessageCDirty = $false
        }
    }

    [Void]WriteMessageComposite(
        [ATString[]]$Composite
    ) {
        $this.MessageHistory[[MessageWindow]::MessageHistoryARef].CompositeActual = [List[ATString]]::new($this.MessageHistory[[MessageWindow]::MessageHistoryBRef].CompositeActual)
        $this.MessageHistory[[MessageWindow]::MessageHistoryBRef].CompositeActual = [List[ATString]]::new($this.MessageHistory[[MessageWindow]::MessageHistoryCRef].CompositeActual)
        $this.MessageHistory[[MessageWindow]::MessageHistoryCRef].CompositeActual = [List[ATString]]::new($Composite)
        $this.MessageADirty                                                       = $true
        $this.MessageBDirty                                                       = $true
        $this.MessageCDirty                                                       = $true
    }

    [Void]WriteBadCommandMessage(
        [String]$Command
    ) {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleRedDark24]::new()
                    Decorations     = [ATDecoration]@{
                        Blink = $true
                    }
                }
                UserData   = "$($Command)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' isn''t a valid command.'
                UseATReset = $true
            }
        ))
    }

    [Void]WriteBadArg0Message(
        [String]$Command,
        [String]$Arg0
    ) {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = 'We can''t '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleYellowDark24]::new()
                    Decorations     = [ATDecoration]@{
                        Blink = $true
                    }
                }
                UserData   = "$($Command)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' with a(n) '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                    Decorations     = [ATDecoration]@{
                        Blink = $true
                    }
                }
                UserData   = "$($Arg0)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = '.'
                UseATReset = $true
            }
        ))
    }

    [Void]WriteBadArg1Message(
        [String]$Command,
        [String]$Arg0,
        [String]$Arg1
    ) {
		$this.WriteMessageComposite(@(
			[ATString]@{
				Prefix = [ATStringPrefix]@{
					ForegroundColor = [CCTextDefault24]::new()
				}
				UserData   = 'We can''t '
				UseATReset = $true
			},
			[ATString]@{
				Prefix = [ATStringPrefix]@{
					ForegroundColor = [CCAppleYellowDark24]::new()
					Decorations     = [ATDecoration]@{
						Blink = $true
					}
				}
				UserData   = "$($Command)"
				UseATReset = $true
			},
			[ATString]@{
				Prefix = [ATStringPrefix]@{
					ForegroundColor = [CCTextDefault24]::new()
				}
				UserData   = ' with a(n) '
				UseATReset = $true
			},
			[ATString]@{
				Prefix = [ATStringPrefix]@{
					ForegroundColor = [CCAppleYellowDark24]::new()
					Decorations     = [ATDecoration]@{
						Blink = $true
					}
				}
				UserData   = "$($Arg0)"
				UseATReset = $true
			},
			[ATString]@{
				Prefix = [ATStringPrefix]@{
					ForegroundColor = [CCTextDefault24]::new()
				}
				UserData   = ' and a(n) '
				UseATReset = $true
			},
			[ATString]@{
				Prefix = [ATStringPrefix]@{
					ForegroundColor = [CCAppleYellowDark24]::new()
					Decorations     = [ATDecoration]@{
						Blink = $true
					}
				}
				UserData   = "$($Arg1)"
				UseATReset = $true
			},
			[ATString]@{
				Prefix = [ATStringPrefix]@{
					ForegroundColor = [CCTextDefault24]::new()
				}
				UserData   = '.'
				UseATReset = $true
			}
		))
    }

    [Void]WriteSomethingBadMessage() {
		$this.WriteMessageComposite(@(
			[ATString]@{
				Prefix = [ATStringPrefix]@{
					ForegroundColor = [CCTextDefault24]::new()
				}
				UserData   = 'I''m God, and I don''t know what just happened...'
				UseATReset = $true
			}
		))
    }

    [Void]WriteInvisibleWallEncounteredMessage() {
		$this.WriteMessageComposite(@(
			[ATString]@{
				Prefix = [ATStringPrefix]@{
					ForegroundColor = [CCTextDefault24]::new()
				}
				UserData   = 'The invisible wall blocks your path...'
				UseATReset = $true
			}
		))
    }

    [Void]WriteYouShallNotPassMessage() {
		$this.WriteMessageComposite(@(
			[ATString]@{
				Prefix = [ATStringPrefix]@{
					ForegroundColor = [CCTextDefault24]::new()
				}
				UserData   = 'The path you asked for is impossible...'
				UseATReset = $true
			}
		))
    }

    [Void]WriteMapNoItemsFoundMessage() {
		$this.WriteMessageComposite(@(
			[ATString]@{
				Prefix = [ATStringPrefix]@{
					ForegroundColor = [CCTextDefault24]::new()
				}
				UserData   = 'There''s nothing of interest here.'
				UseATReset = $true
			}
		))
    }

    [Void]WriteMapInvalidItemMessage(
        [String]$ItemName
    ) {
		$this.WriteMessageComposite(@(
			[ATString]@{
				Prefix = [ATStringPrefix]@{
					ForegroundColor = [CCTextDefault24]::new()
				}
				UserData   = 'There''s no '
				UseATReset = $true
			},
			[ATString]@{
				Prefix = [ATStringPrefix]@{
					ForegroundColor = [CCAppleYellowDark24]::new()
					Decorations     = [ATDecoration]@{
						Blink = $true
					}
				}
				UserData   = "$($ItemName)"
				UseATReset = $true
			},
			[ATString]@{
				Prefix = [ATStringPrefix]@{
					ForegroundColor = [CCTextDefault24]::new()
				}
				UserData   = ' here.'
				UseATReset = $true
			}
		))
    }

    [Void]WriteItemTakenMessage(
        [String]$ItemName
    ) {
		$this.WriteMessageComposite(@(
			[ATString]@{
				Prefix = [ATStringPrefix]@{
					ForegroundColor = [CCTextDefault24]::new()
				}
				UserData   = 'I''ve taken the '
				UseATReset = $true
			},
			[ATString]@{
				Prefix = [ATStringPrefix]@{
					ForegroundColor = [CCAppleYellowDark24]::new()
					Decorations     = [ATDecoration]@{
						Blink = $true
					}
				}
				UserData   = "$($ItemName)"
				UseATReset = $true
			},
			[ATString]@{
				Prefix = [ATStringPrefix]@{
					ForegroundColor = [CCTextDefault24]::new()
				}
				UserData   = ' and put it in my pocket.'
				UseATReset = $true
			}
		))
    }

    [Void]WriteItemCantTakeMessage(
        [String]$ItemName
    ) {
		$this.WriteMessageComposite(@(
			[ATString]@{
				Prefix = [ATStringPrefix]@{
					ForegroundColor = [CCTextDefault24]::new()
				}
				UserData   = 'It''s not possible to take the '
				UseATReset = $true
			},
			[ATString]@{
				Prefix = [ATStringPrefix]@{
					ForegroundColor = [CCAppleYellowDark24]::new()
					Decorations     = [ATDecoration]@{
						Blink = $true
					}
				}
				UserData   = "$($ItemName)"
				UseATReset = $true
			},
			[ATString]@{
				Prefix = [ATStringPrefix]@{
					ForegroundColor = [CCTextDefault24]::new()
				}
				UserData   = '.'
				UseATReset = $true
			}
		))
    }

    [Void]WriteCmdExtraArgsWarning(
        [String]$Command,
        [String[]]$ExtraArgs
    ) {
		$this.WriteMessageComposite(@(
			[ATString]@{
				Prefix = [ATStringPrefix]@{
					ForegroundColor = [CCAppleNPinkLight24]::new()
					Decorations     = [ATDecoration]@{
						Blink = $true
					}
				}
				UserData   = "$($Command)"
				UseATReset = $true
			},
			[ATString]@{
				Prefix = [ATStringPrefix]@{
					ForegroundColor = [CCTextDefault24]::new()
				}
				UserData   = ' has garbage: '
				UseATReset = $true
			},
			[ATString]@{
				Prefix = [ATStringPrefix]@{
					ForegroundColor = [CCAppleNYellowDark24]::new()
					Decorations     = [ATDecoration]@{
						Blink = $true
					}
				}
				UserData   = "$($ExtraArgs)"
				UseATReset = $true
			}
		))
    }

    [Void]WriteBadCommandRetortMessage() {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleNRedDark24]::new()
                }
                UserData   = "$($Script:BadCommandRetorts | Get-Random)"
                UseATReset = $true
            }
        ))
    }

    [Void]WriteCantUseItemMessage(
        [String]$Source,
        [String]$Target
    ) {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleRedDark24]::new()
                }
                UserData   = 'Can''t use a(n) '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleYellowDark24]::new()
                }
                UserData   = "$($Source)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleRedDark24]::new()
                }
                UserData   = ' on a(n) '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleYellowDark24]::new()
                }
                UserData   = "$($Target)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleRedDark24]::new()
                }
                UserData   = '.'
                UseATReset = $true
            }
        ))
    }

    [Void]WriteCantUseItemOnSelfMessage(
        [String]$ItemName
    ) {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleRedDark24]::new()
                }
                UserData   = 'I can''t use '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleYellowDark24]::new()
                }
                UserData   = "$($ItemName)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleRedDark24]::new()
                }
                UserData   = ' on myself.'
                UseATReset = $true
            }
        ))
    }

    [Void]WriteNoItemInInvMessage(
        [String]$DesiredItem
    ) {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleRedDark24]::new()
                }
                UserData   = 'There ain''t no '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleYellowDark24]::new()
                }
                UserData   = "$($DesiredItem)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleRedDark24]::new()
                }
                UserData   = ' in your pockets guv''.'
                UseATReset = $true
            }
        ))
    }

    [Void]WriteNoItemTargetMessage(
        [String]$Source
    ) {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleRedDark24]::new()
                }
                UserData   = 'You need to tell me what you want to use the '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleYellowDark24]::new()
                }
                UserData   = "$($Source)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleRedDark24]::new()
                }
                UserData   = ' on.'
                UseATReset = $true
            }
        ))
    }

    [Void]WriteItemUseUnsureMessage(
        [String]$Target
    ) {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleRedDark24]::new()
                }
                UserData   = 'I have no idea how to use a(n) '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleYellowDark24]::new()
                }
                UserData   = "$($Target)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleRedDark24]::new()
                }
                UserData   = '.'
                UseATReset = $true
            }
        ))
    }

    [Void]WriteCantDropMultMessage() {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleYellowDark24]::new()
                }
                UserData   = 'Can''t drop all those items at once, bruh.'
                UseATReset = $true
            }
        ))
    }

    [Void]WriteItemDroppedMessage(
        [String]$ItemName
    ) {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = 'Dropped '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleYellowDark24]::new()
                }
                UserData   = "$($ItemName)"
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' from your inventory.'
                UseATReset = $true
            }
        ))
    }

    [Void]WriteMilkUseOkayMessage() {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = 'Hmmm. Delicious cow juice.'
                UseATReset = $true
            }
        ))
    }

    [Void]WriteMilkUseSpoiledMessage() {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = 'Now that wasn''t very smart, was it?'
                UseATReset = $true
            }
        ))
    }

    [Void]WriteMilkUseNotNowMessage() {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = 'There''s no need to drink this now.'
                UseATReset = $true
            }
        ))
    }

    [Void]WriteTiedRopeToTreeMessage() {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = 'I''ve tied the '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleYellowDark24]::new()
                }
                UserData   = 'Rope'
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = ' to the '
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleYellowDark24]::new()
                }
                UserData   = 'Tree'
                UseATReset = $true
            },
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = '.'
                UseATReset = $true
            }
        ))
    }

    [Void]WriteLookMessage(
        [String]$ItemSetA,
        [String]$ItemSetB,
        [Boolean]$UseSetB
    ) {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCTextDefault24]::new()
                }
                UserData   = 'I can see the following things here:'
                UseATReset = $true
            }
        ))
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleYellowLight24]::new()
                }
                UserData   = "$($ItemSetA)"
                UseATReset = $true
            }
        ))
        If($UseSetB -EQ $true) {
            $this.WriteMessageComposite(@(
                [ATString]@{
                    Prefix = [ATStringPrefix]@{
                        ForegroundColor = [CCAppleYellowLight24]::new()
                    }
                    UserData   = "$($ItemSetB)"
                    UseATReset = $true
                }
            ))
        }
    }

    [Void]WriteItemExamineMessage(
        [String]$ExamineString
    ) {
        $this.WriteMessageComposite(@(
            [ATString]@{
                Prefix = [ATStringPrefix]@{
                    ForegroundColor = [CCAppleMintDark24]::new()
                }
                UserData   = "$($ExamineString)"
                UseATReset = $true
            }
        ))
    }

    [Void]SetAllDirty() {
        ([WindowBase]$this).SetAllDirty()

        $this.MessageADirty = $true
        $this.MessageBDirty = $true
        $this.MessageCDirty = $true
    }
}
