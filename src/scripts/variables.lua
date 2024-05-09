--[[
It's a file, which contain static variables for my mod.
I am trying to replace all static variables into TUNINGS or STRINGS.
So it's can be more comfortable so change something and don't search all of it in code.
--]]
TUNING = GLOBAL.TUNING
STRINGS = GLOBAL.STRINGS

--********************TUNINGS*********************************
	TUNING.LICKING_HEALTH = GetModConfigData("Licking's Health")
	TUNING.LICKING_DAMAGE = GetModConfigData("Licking's Damage")
	TUNING.LICKING_ATTACK_SPEED = GetModConfigData("Licking's Attack Period")
	TUNING.LICKING_ATTACK_RANGE = 7
	TUNING.LICKING_WALK_SPEED = 9

	TUNING.ISO_LICKING_HEALTH = GetModConfigData("Ice Licking's Health")
	TUNING.ISO_LICKING_DAMAGE = 0
	TUNING.ISO_LICKING_ATTACK_SPEED = 5
	TUNING.ISO_LICKING_ATTACK_RANGE = 0
	TUNING.ISO_LICKING_WALK_SPEED = 9

	TUNING.TPG_LICKING_HEALTH = GetModConfigData("Epic Licking's Health")
	TUNING.TPG_LICKING_DAMAGE = GetModConfigData("Epic Licking's Damage")
	TUNING.TPG_LICKING_ATTACK_SPEED = GetModConfigData("Epic Licking's Attack Period")
	TUNING.TPG_LICKING_ATTACK_RANGE = 7
	TUNING.TPG_LICKING_WALK_SPEED = 9
	
	TUNING.LICKING_SLEEP_NEAR_LEADER_DISTANCE = 2
	TUNING.LICKING_WAKE_TO_FOLLOW_DISTANCE = 3
--************************************************************
	STRINGS.RECIPE_DESC.LICKING_EYEBONE = "The FirsT EPIC gift from the Sky"
	STRINGS.NAMES.LICKING_EYEBONE = "Licking's Eyebone (uncommon)"
    GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.LICKING_EYEBONE = "This is omen of his service!"

	STRINGS.NAMES.LICKING = "Licking"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.LICKING = {}
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.LICKING.GENERIC = "My best friend!"
    STRINGS.CHARACTERS.WX78.DESCRIBE.LICKING = "I feel 100110101101 from this creature!"
    STRINGS.CHARACTERS.WILLOW.DESCRIBE.LICKING = "It's so hairy!"
    STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.LICKING = "Should read up on these guys."
    STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.LICKING = "Guess I could eat him?"
    STRINGS.CHARACTERS.WENDY.DESCRIBE.LICKING = "Think I'll protect him!"

	STRINGS.RECIPE_DESC.ISO_LICKING_EYEBONE = "The SeconD EPIC gift from the Sky"
	STRINGS.NAMES.ISO_LICKING_EYEBONE = "Ice Licking's Eyebone (rare)"
    GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.ISO_LICKING_EYEBONE = "This is omen of his service!"
	
	STRINGS.NAMES.ISO_LICKING = "Cold Licking"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.ISO_LICKING = {}
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.ISO_LICKING.GENERIC = "Oh, white-hairs thing!"
    STRINGS.CHARACTERS.WX78.DESCRIBE.ISO_LICKING = "I feel 10101 from this creature!"
    STRINGS.CHARACTERS.WILLOW.DESCRIBE.ISO_LICKING = "It's so hairy!"
    STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.ISO_LICKING = "Should read up on these guys."
    STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.ISO_LICKING = "Guess I could eat him?"
    STRINGS.CHARACTERS.WENDY.DESCRIBE.ISO_LICKING = "Think, I'll protect him from SUN!"

	STRINGS.RECIPE_DESC.TPG_LICKING_EYEBONE = "The ThirD EPIC gift from the Sky"
	STRINGS.NAMES.TPG_LICKING_EYEBONE = "Epic Licking's Eyebone (rare)"
    GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.TPG_LICKING_EYEBONE = "With this I can come with him"
	
	STRINGS.NAMES.TPG_LICKING = "Epic Licking"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.TPG_LICKING = {}
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.TPG_LICKING.GENERIC = "Oh, He is epic!"
    STRINGS.CHARACTERS.WX78.DESCRIBE.TPG_LICKING = "1001 0110 1011!"
    STRINGS.CHARACTERS.WILLOW.DESCRIBE.TPG_LICKING = "It's so epic-hairy!"
    STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.TPG_LICKING = "Impossible to believe in this..."
    STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.TPG_LICKING = "Guess I could protect him?"
    STRINGS.CHARACTERS.WENDY.DESCRIBE.TPG_LICKING = "Think, he is so strong!"
--************************************************************

--**	РЕПЛИКИ		**--
	STRINGS.LICKING_TALK_FOLLOW1 = "I am following you!"
	STRINGS.LICKING_TALK_FOLLOW2 = "I'll be near!"
	STRINGS.LICKING_TALK_STOPFOLLOW1 = "I am only myself!"
	STRINGS.LICKING_TALK_STOPFOLLOW2 = "I want to go with myself"
	STRINGS.LICKING_TALK_IMMORTAL = "Immortality!" -- не используется после 1.8
	STRINGS.LICKING_TALK_TOOFAR = "Too far for fight..."
	STRINGS.LICKING_TALK_FIGHT1 = "By your command, attack!"
	STRINGS.LICKING_TALK_FIGHT2 = "Follow me into battle!"
	STRINGS.LICKING_TALK_FIGHT3 = "I will crush you!"
	STRINGS.LICKING_TALK_FIGHT4 = "Lickings attack!"
	STRINGS.LICKING_TALK_PROTECT1 = "I'll protect my leader!"
	STRINGS.LICKING_TALK_PROTECT2 = "I'll protect you!"	
	STRINGS.LICKING_TALK_PROTECT3 = "I am your reinforcement!"	
	STRINGS.LICKING_TALK_PANICFIRE = "Don't panic! Aaa!"
	STRINGS.LICKING_TALK_DMGBYHERO1 = "What have I done to you?"
	STRINGS.LICKING_TALK_DMGBYHERO2 = "I am on your side!!"
	STRINGS.LICKING_TALK_DMGBYHERO3 = "Why me?!"
	STRINGS.LICKING_TALK_OPEN1 = "There is all"
	STRINGS.LICKING_TALK_OPEN2 = "Store it"
	STRINGS.LICKING_TALK_CLOSE1 = "It's all?"
	STRINGS.LICKING_TALK_CLOSE2 = "I'll protect all of your things!"
	--Still not using (come in next update, I hope)
	STRINGS.LICKING_TALK_DEATH1 = "Sorry my friend, I can't live anymore."
	STRINGS.LICKING_TALK_DEATH2 = "There is no glory in defeat!"
	STRINGS.LICKING_TALK_DEATH3 = "I can't...resist..."

	STRINGS.ISO_LICKING_TALK_FOLLOW1 = "By your command!"
	STRINGS.ISO_LICKING_TALK_FOLLOW2 = "I am there."
	STRINGS.ISO_LICKING_TALK_STOPFOLLOW1 = "I can't follow you anymore"
	STRINGS.ISO_LICKING_TALK_STOPFOLLOW2 = "I'll wait there"
	STRINGS.ISO_LICKING_TALK_IMMORTAL = "God of Lickings saving me" -- не используется после 1.8
	STRINGS.ISO_LICKING_TALK_TOOFAR = "It's too far from my home"
	STRINGS.ISO_LICKING_TALK_FIGHT1 = "I have no Damage"
	STRINGS.ISO_LICKING_TALK_FIGHT2 = "I can't..."
	STRINGS.ISO_LICKING_TALK_FIGHT3 = "I am so weak"
	STRINGS.ISO_LICKING_TALK_FIGHT4 = "I afraid them"
	STRINGS.ISO_LICKING_TALK_PROTECT1 = "I can't protect you"
	STRINGS.ISO_LICKING_TALK_PROTECT2 = "I hope you can fight yourself"	
	STRINGS.ISO_LICKING_TALK_PROTECT3 = "I can't support you"	
	STRINGS.ISO_LICKING_TALK_PANICFIRE = "I HATE FIRE!!!"
	STRINGS.ISO_LICKING_TALK_DMGBYHERO1 = "What have I done to you?"
	STRINGS.ISO_LICKING_TALK_DMGBYHERO2 = "Please no!"
	STRINGS.ISO_LICKING_TALK_DMGBYHERO3 = "I have not weapon!"
	STRINGS.ISO_LICKING_TALK_OPEN1 = "Want to eat?"
	STRINGS.ISO_LICKING_TALK_OPEN2 = "I'll not eat it."
	STRINGS.ISO_LICKING_TALK_CLOSE1 = "Fridge activating"
	STRINGS.ISO_LICKING_TALK_CLOSE2 = "I'll protect from spoiling"
	--Still not using (come in next update, I hope)
	STRINGS.ISO_LICKING_TALK_DEATH1 = "Death, it comes to me now."
	STRINGS.ISO_LICKING_TALK_DEATH2 = "You, have no honor."
	STRINGS.ISO_LICKING_TALK_DEATH3 = "Noo-ooogh..."
	
	STRINGS.TPG_LICKING_TALK_FOLLOW1 = "Are you follow me?"
	STRINGS.TPG_LICKING_TALK_FOLLOW2 = "Greatest one there!"
	STRINGS.TPG_LICKING_TALK_STOPFOLLOW1 = "I don't want to follow you"
	STRINGS.TPG_LICKING_TALK_STOPFOLLOW2 = "I'll not be near!"
	STRINGS.TPG_LICKING_TALK_IMMORTAL = "I'm too EPIC for Immortality!" -- не используется после 1.8
	STRINGS.TPG_LICKING_TALK_TOOFAR = "Oh, I missed you."
	STRINGS.TPG_LICKING_TALK_FIGHT1 = "Attacking!"
	STRINGS.TPG_LICKING_TALK_FIGHT2 = "I'll show you my might!"
	STRINGS.TPG_LICKING_TALK_FIGHT3 = "Licking's attack!"
	STRINGS.TPG_LICKING_TALK_FIGHT4 = "Afraid me!"
	STRINGS.TPG_LICKING_TALK_PROTECT1 = "I'll protect you!"
	STRINGS.TPG_LICKING_TALK_PROTECT2 = "I'll fight on your side!"	
	STRINGS.TPG_LICKING_TALK_PROTECT3 = "Want to fight?"
	STRINGS.TPG_LICKING_TALK_PANICFIRE = "I don't like this fire."
	STRINGS.TPG_LICKING_TALK_DMGBYHERO1 = "I am angry!"
	STRINGS.TPG_LICKING_TALK_DMGBYHERO2 = "What are you doing?!"
	STRINGS.TPG_LICKING_TALK_DMGBYHERO3 = "One more, and I'll attack you!"
	STRINGS.TPG_LICKING_TALK_SHAVE = "I don't need so much hairs."
	--Still not using (come in next update, I hope)
	STRINGS.ISO_LICKING_TALK_DEATH1 = "This cannot be! "
	STRINGS.ISO_LICKING_TALK_DEATH2 = "The end already? "
	STRINGS.ISO_LICKING_TALK_DEATH3 = "Death finds me at last."
--*****************************************************
--[[
*
*	BOOKs of Lickings ADDON for ver 1.8 or higher.
*
--]]
--********************TUNINGS***************************
	--Helper's Variables
	TUNING.SLEEP_NEAR_LEADER_DISTANCE = 2
	TUNING.WAKE_TO_FOLLOW_DISTANCE = 3	--Dist to wakeup
	TUNING.GH_HELPER_HP = 600			--Health
	TUNING.GH_HELPER_WALKSPEED = 6		--Walk Speed
	TUNING.GH_HELPER_SLEEP_RESIST = 3	--SleepResist
	TUNING.GH_HELPER_ATACK_SPEED = 2	--Attack Speed
	TUNING.GH_HELPER_ATACK_RANGE = 7	--Attack Range
	TUNING.GH_HELPER_ATACK_DAMAGE = 30	--Attack Damage
	TUNING.GH_HELPER_DEATH_TIME = 20	--Sec before Death
	--Blessing Licking Book Variables
	TUNING.GH_BL_DELTA_SANITY = -10		--How much we'll lost Sanity
	TUNING.GH_BL_DELTA_LTRUST = 45		--How much we'll get LT
	--Licking Trust Default Settings
	TUNING.GH_LT_DROPRATE = 1			-- Коэфициент траты 1 - количественный
	TUNING.GH_LT_BURNRATE = .05			-- Коэфициент траты 2 - процентный
	TUNING.GH_LT_DROPPING = -1			-- Коэфициент траты 3 - Равен либо 1 либо -1
	--Book: Licking Help
	TUNING.GH_LH_NUMBEROFHELPERS = 8	--Max helpers number
	TUNING.GH_LH_COST = 10				--How much licking_trust we lost when Casting
	TUNING.GH_LH_MINTOCAST = 20 		--Minimum of licking_trust to Cast
	TUNING.GH_LH_COOLDOWN = 25			--CoolDown
--********************Books of Licking*******************
	STRINGS.RECIPE_DESC.BLESSING_LICKING = "Literature of Lickings"
	STRINGS.NAMES.BLESSING_LICKING = "Trust of Lickings (spell)"
    GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.BLESSING_LICKING = "This book give power of Lickings!"
	
	STRINGS.RECIPE_DESC.LICKING_HELP = "Literature of Lickings"
	STRINGS.NAMES.LICKING_HELP = "Lickings Help (spell)"
    GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.LICKING_HELP = "If I read this, they will come!"
	
	STRINGS.RECIPE_DESC.LICKINGS_PELT = "Who wear this will come their friend."
	STRINGS.NAMES.LICKINGS_PELT = "Licking's Pelt"
    GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.LICKINGS_PELT = "They starting to believe in me!"
--**********************Strings*************************
	STRINGS.CASTER_COOLDOWN1 = "It's not time yet!"
	STRINGS.CASTER_COOLDOWN2 = "I'm not ready!"
	STRINGS.CASTER_COOLDOWN3 = "Not so fast."
	STRINGS.CASTER_NO_MANA1 = "No mana."
	STRINGS.CASTER_NO_MANA2 = "Not enough mana."
	STRINGS.CASTER_NO_MANA3 = "It's not enough mana!"
	STRINGS.CASTING_LICKINGHELP3 = "Warguard's Legion, I need your support!"
	STRINGS.CASTING_LICKINGHELP2 = "Warguards of Lickings, Come to me!"
	STRINGS.CASTING_LICKINGHELP1 = "Warguards, it is time to pay them back!"
	STRINGS.NAMES.LICKING_HELPER = "Licking's Guardian"
	STRINGS.CHARACTERS.GENERIC.DESCRIBE.LICKING_HELPER = {}
	STRINGS.CHARACTERS.GENERIC.DESCRIBE.LICKING_HELPER.GENERIC = "He came to protect me!"
	STRINGS.CHARACTERS.WX78.DESCRIBE.LICKING_HELPER = "What the adorable creature?"
	STRINGS.CHARACTERS.WILLOW.DESCRIBE.LICKING_HELPER = "It's so hairy!"
	STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.LICKING_HELPER = "He can defend me?"
	STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.LICKING_HELPER = "It's tasty?"
	STRINGS.CHARACTERS.WENDY.DESCRIBE.LICKING_HELPER = "Sister, don't hit them!"
	STRINGS.LICKING_HELPER_TALK_FOLLOW1 = "I am following you!"
	STRINGS.LICKING_HELPER_TALK_STOPFOLLOW1 = "I am only myself!"
	STRINGS.LICKING_HELPER_TALK_FOLLOW2 = "I'll be near!"
	STRINGS.LICKING_HELPER_TALK_STOPFOLLOW2 = "I want to go with myself"
	STRINGS.LICKING_HELPER_TALK_IMMORTAL = "Immortality!" -- не используется после 1.8
	STRINGS.LICKING_HELPER_TALK_TOOFAR = "Too far for fight..."
	STRINGS.LICKING_HELPER_TALK_FIGHT1 = "By your command, attack!"
	STRINGS.LICKING_HELPER_TALK_FIGHT2 = "Follow me into battle!"
	STRINGS.LICKING_HELPER_TALK_FIGHT3 = "My honor is fight for my leader!"
	STRINGS.LICKING_HELPER_TALK_FIGHT4 = "Lickings attack!"
	STRINGS.LICKING_HELPER_TALK_PROTECT1 = "Attack him!"
	STRINGS.LICKING_HELPER_TALK_PROTECT2 = "I'll protect you!"	
	STRINGS.LICKING_HELPER_TALK_PROTECT3 = "I will fight for your life!"	
	STRINGS.LICKING_HELPER_TALK_PANICFIRE = "I am in FIRE!!1"
	STRINGS.LICKING_HELPER_TALK_DMGBYHERO1 = "What have I done to you?"
	STRINGS.LICKING_HELPER_TALK_DMGBYHERO2 = "I am on your side!!"
	STRINGS.LICKING_HELPER_TALK_DMGBYHERO3 = "Why me?!"
--*****************************************************