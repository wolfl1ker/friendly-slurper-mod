--[[
**************************
	CURENT VERSION: 1.8.4 (FS and BoL);
**************************
--]]
name = "Friendly Slurper"
description = "Meet your own friendly Slurper! They can speak with you! Click on \"P\" in game to settings\nIf you like this mod, pls add a good estimation at mod page.\nThanks for play with my mod!"
author = "Wolfl1ker"
forumthread = "19505-Modders-Your-new-friend-at-Klei!"
version = "1.8.4"
api_version = 6
dont_starve_compatible = true
reign_of_giants_compatible = true
shipwrecked_compatible = true
icon_atlas = "lickin.xml"
icon = "lickin.tex"

configuration_options =
{
	{
		name = "Licking's Health",
		options =
		{
			{description = "400", data = 400},
			{description = "450", data = 450},
			{description = "500", data = 500},
			{description = "550", data = 550},
			{description = "600", data = 600},
			{description = "650", data = 650},
			{description = "700", data = 700},
			{description = "750", data = 750},
			{description = "800", data = 800},
			{description = "850", data = 850}
		},
		default = 600,
	},
	{
		name = "Ice Licking's Health",
		options =
		{
			{description = "350", data = 350},
			{description = "400", data = 400},
			{description = "450", data = 450},
			{description = "500", data = 500},
			{description = "550", data = 550},
			{description = "600", data = 600},
			{description = "650", data = 650},
			{description = "700", data = 750},
			{description = "750", data = 750},
			{description = "800", data = 800}
		},
		default = 500,
	},
	{	
		name = "Epic Licking's Health",
		options =
		{
			{description = "450", data = 450},
			{description = "500", data = 500},
			{description = "550", data = 550},
			{description = "600", data = 600},
			{description = "650", data = 650},
			{description = "700", data = 700},
			{description = "750", data = 750},
			{description = "800", data = 800},
			{description = "850", data = 850},
			{description = "900", data = 900}
		},
		default = 700,
	},
	{	
		name = "Licking's Damage",
		options =
		{
			{description = "30", data = 30},
			{description = "34", data = 34},
			{description = "37", data = 37},
			{description = "40", data = 40},
			{description = "44", data = 44},
			{description = "47", data = 47},
			{description = "50", data = 50},
			{description = "54", data = 54},
			{description = "57", data = 57},
			{description = "60", data = 60}
		},
		default = 40,
	},
	{	
		name = "Epic Licking's Damage",
		options =
		{
			{description = "50", data = 50},
			{description = "54", data = 54},
			{description = "57", data = 57},
			{description = "60", data = 60},
			{description = "64", data = 64},
			{description = "67", data = 67},
			{description = "70", data = 70},
			{description = "74", data = 74},
			{description = "77", data = 77},
			{description = "80", data = 80}
		},
		default = 60,
	},
	{	
		name = "Licking's Attack Period",
		options =
		{
			{description = "2", data = 2},
			{description = "3", data = 3},
			{description = "4", data = 4}
		},
		default = 3,
	},
		{	
		name = "Epic Licking's Attack Period",
		options =
		{
			{description = "2", data = 2},
			{description = "3", data = 3},
			{description = "4", data = 4}
		},
		default = 2,
	},
	{	
		name = "They Can Talk",
		options =
		{
			{description = "Yes!", data = 1},
			{description = "No!", data = 0}
		},
		default = 1,
	},
	{	
		name = "Ice Licking works as Fridge",
		options =
		{
			{description = "Yes!", data = 1},
			{description = "No!", data = 0}
		},
		default = 1,
	},
	{	
		name = "They Can Die?",
		options =
		{
			{description = "Yes!", data = 1},
			{description = "No!", data = 0}
		},
		default = 1,
	},
}