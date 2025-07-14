using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# LOAD STRINGS
#
###############################################################################

[String]$Script:ModuleStringLoad = "
██╗      ██████╗  █████╗ ██████╗ ██╗███╗   ██╗ ██████╗ 
██║     ██╔═══██╗██╔══██╗██╔══██╗██║████╗  ██║██╔════╝ 
██║     ██║   ██║███████║██║  ██║██║██╔██╗ ██║██║  ███╗
██║     ██║   ██║██╔══██║██║  ██║██║██║╚██╗██║██║   ██║
███████╗╚██████╔╝██║  ██║██████╔╝██║██║ ╚████║╚██████╔╝
╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚═════╝ ╚═╝╚═╝  ╚═══╝ ╚═════╝ "

[String]$Script:ModuleStringEldoria = "
███████╗██╗     ██████╗  ██████╗ ██████╗ ██╗ █████╗ 
██╔════╝██║     ██╔══██╗██╔═══██╗██╔══██╗██║██╔══██╗
█████╗  ██║     ██║  ██║██║   ██║██████╔╝██║███████║
██╔══╝  ██║     ██║  ██║██║   ██║██╔══██╗██║██╔══██║
███████╗███████╗██████╔╝╚██████╔╝██║  ██║██║██║  ██║
╚══════╝╚══════╝╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚═╝╚═╝  ╚═╝"

[String]$Script:ProgressActivity = 'Putting shit together'

[String[]]$Script:EnumLoadStrings = @(
    'Enums. Still loading.',
    'Oh joy, more enums.',
    'Loading enumerations... eventually.',
    'Just what we needed: enums.',
    'Behold! The enums cometh!',
    'Enums: The Never-Ending Story',
    'Hold your breath, enums incoming.',
    'Yup, enumerations. Again.',
    'More enums to not read.',
    'Enums: The Thrill is Real.'
)

[String[]]$Script:ColorLoadStrings = @(
    'Colors? In this economy?',
    'Brace yourselves, the colors are coming.',
    'Loading color support... eventually.',
    'Oh good, more hues.',
    'Still waiting for my crayons.',
    'Surprise! We have colors now!',
    'Yes, moar RGBs.',
    'Color Support: Maximum Thrill.',
    'Prepare for Retinal Overload.',
    'Finally, no more beige.'
)

[String[]]$Script:FnlLoadStrings = @(
    'Fast noise, lite? Sure.',
    'Loading ''fast'' noise.',
    'Fast noise, slow load.',
    'Lite noise, heavy burden.'
)

[String[]]$Script:AnsiLoadStrings = @(
    'ANSI Support? How quaint.',
    'Get ready for retro.',
    'Behold, the text art.',
    'Loading terminal nostalgia.'
)

[String[]]$Script:EnemyLoadStrings = @(
    'Loading pixels of doom.',
    'Get ready for bad guys.',
    'More foes.',
    'Loading target practice.'
)

[String[]]$Script:MapLoadStrings = @(
    'Get ready to get lost.',
    'Cartographic chaos inbound.',
    'Your next adventure (maybe).'
)

[String[]]$Script:MapObjLoadStrings = @(
    'Loading clutter.',
    'Planting bushes and stuff.',
    'Randomizing props.',
    'Throwing rocks around.',
    'Clearing paths for you.'
)

[String[]]$Script:BattleEngineLoadStrings = @(
    'Lettings the fighters out.',
    'Sorting out the brawls.',
    'Putting the rage on the streets.'
)

[String[]]$Script:BattleTechniqueLoadStrings = @(
    'Reading technique scrolls.',
    'Learning Crap-Fu.'
)

[String[]]$Script:EnemyEntityLoadStrings = @(
    'Baddies are coming for ya.',
    'Firing pest control.',
    'Enemies, because who needs friends.'
)

[String[]]$Script:EquipBasicLoadStrings = @(
    'Piling up the junk.',
    'Gathering the essentials.',
    'Bear Necesseties.'
)

[String[]]$Script:ArmorLoadStrings = @(
    'Buying fashionable armor.',
    'Body protection loading.'
)

[String[]]$Script:BootLoadStrings = @(
    'Engaging in orbital foot-knotting.',
    'Initiation pedestrian mode.',
    'Wrestling with the laces.'
)

[String[]]$Script:CapeLoadStrings = @(
    'Borrowing Superman''s cape.',
    'Wrapping my blanket around.'
)

[String[]]$Script:GauntletLoadStrings = @(
    'Securing the hand-hammers.',
    'Getting my iron grip on.'
)

[String[]]$Script:GreavesLoadStrings = @(
    'Preparing the anti-kick defenses.',
    'Leg-clunk protocol, engage.'
)

[String[]]$Script:HelmetLoadStrings = @(
    'Getting thinking caps.',
    'Buying pricey headwear.'
)

[String[]]$Script:JewelryLoadStrings = @(
    'Mother of Pearl these are expensive!',
    'AksessOreyezing.'
)

[String[]]$Script:PauldronLoadStrings = @(
    'Getting ready to play footbawl.'
)

[String[]]$Script:WeaponLoadStrings = @(
    'I''m feeling lucky, punk.',
    'Star Warz',
    'Pew pew, bia',
    'Getting sweet nunchuck skills ready.'
)

[String[]]$Script:WindowSupportLoadStrings = @(
    'Buffing the windows.',
    'I DON''T DO WINDOZE!'
)

[String[]]$Script:WindowBuildLoadStrings = @(
    'House of glass?',
    'Windurz are dun.'
)

[String[]]$Script:FinishUpLoadStrings = @(
    'Putting the bow on top.',
    'Is it Christmas yet?'
)

[String[]]$Script:SixelLoadStrings = @(
    'Getting super fancy art.',
    'The Miami Vice of Terminal Programs.'
)

[String[]]$Script:GlobalsLoadStrings = @(
    'The dreaded globals!',
    'Tell me I''m wrong, I dare ya!'
)
