--[[
**************************
	CURENT VERSION: 1.8.4 (FS and BoL);
**************************
--]]
-- ***********************************************
-- Following code from user @Maris. I found it on forums in question: "How to Add function to ALL custom characters"
_G=GLOBAL
if not _G.rawget(_G,"mods") then _G.rawset(_G,"mods",{}) end
if not _G.mods.player_preinit_fns then
    _G.mods.player_preinit_fns={}
    --Dirty hack
    local old_MakePlayerCharacter = _G.require("prefabs/player_common")
    local function new_MakePlayerCharacter(...)
        local inst=old_MakePlayerCharacter(...)
        for _,v in ipairs(_G.mods.player_preinit_fns) do
            v(inst)
        end
        return inst
    end
    _G.package.loaded["prefabs/player_common"] = new_MakePlayerCharacter
end
 
function AddPlayersPreInit(fn)
    table.insert(_G.mods.player_preinit_fns,fn)
end
 
local player_postinit_fns = {}
function AddPlayersPostInit(fn)
    table.insert(player_postinit_fns,fn)
end
 
local done_players = {}
AddPlayersPreInit(function(inst)
    local s = inst.prefab or inst.name
    if not done_players[s] then
        done_players[s] = true
        AddPrefabPostInit(s,function(inst)
            for _,v in ipairs(player_postinit_fns) do
                v(inst)
            end
        end)
    end
end)
-- ***********************************************

PrefabFiles = {
	-- Friendly Slurper (FS)
	"licking",
	"licking_eyebone",
	"iso_licking_eyebone",
	"iso_licking",
	"tpg_licking_eyebone",
	"tpg_licking",
	 
	-- Book of Lickings (BoL)
	"blessing_licking",
	"licking_help",
	"licking_helper",
	"lickings_pelt",
}

Assets = {
-- Friendly Slurper (FS)
    Asset("ATLAS", "images/inventoryimages/licking_eyebone.xml"),
	Asset("BRAIN", "scripts/brains/lickingbrain.lua"),
	Asset("ATLAS", "images/inventoryimages/iso_licking_eyebone.xml"),
	Asset("BRAIN", "scripts/brains/iso_lickingbrain.lua"),	
    Asset("ATLAS", "images/inventoryimages/tpg_licking_eyebone.xml"),
	Asset("BRAIN", "scripts/brains/tpg_lickingbrain.lua"),
	Asset("ATLAS", "images/licking.xml"),
	Asset("IMAGE", "images/licking.tex"),
	Asset("ATLAS", "images/licking_eyebone.xml"),
	Asset("IMAGE", "images/licking_eyebone.tex"),
	
	-- Book of Lickings (BoL)
	Asset("ANIM", "anim/licking_trust_meter.zip"),
	Asset("ATLAS", "images/inventoryimages/book_licking.xml"),
	Asset("ATLAS", "images/inventoryimages/blessing_licking.xml"),
	Asset("ATLAS", "images/inventoryimages/licking_help.xml"),
	Asset("ATLAS", "images/lickings_tab.xml"),
	Asset("IMAGE", "images/lickings_tab.tex"),
}
AddMinimapAtlas("images/licking_eyebone.xml")
AddMinimapAtlas("images/licking.xml")
modimport("scripts/variables.lua")

RECIPETABS = GLOBAL.RECIPETABS
Recipe = GLOBAL.Recipe
Ingredient = GLOBAL.Ingredient
TECH = GLOBAL.TECH
GetPlayer = GLOBAL.GetPlayer

-- Talking component
local function IcanTALK(inst)
	local Option = GetModConfigData("They Can Talk")
	if Option == 1 then
		inst:AddComponent("talker")
		inst.components.talker.ontalk = ontalk
		inst.components.talker.fontsize = 35
		inst.components.talker.font = TALKINGFONT
		--inst.components.talker.offset = Vector3(0,-400,0)
	end
end

-- Immortal
local function G_Immortality(inst)
	local Option = GetModConfigData("They Can Die?")
	if Option == 1 then
		if inst:HasTag("immortal") then
			inst:RemoveTag("immortal")
		end
	else
		inst:AddTag("immortal")
	end
end

-- Fridge
local function G_Fridge(inst)
	local Option = GetModConfigData("Ice Licking works as Fridge")
	if Option == 0 then
		if inst:HasTag("fridge") then
			inst:RemoveTag("fridge")
		end
	else
		inst:AddTag("fridge")
	end
end

AddPrefabPostInit("iso_licking", G_Fridge)
AddPrefabPostInit("licking", G_Immortality)
AddPrefabPostInit("iso_licking", G_Immortality)
AddPrefabPostInit("tpg_licking", G_Immortality)
AddPrefabPostInit("licking", IcanTALK)
AddPrefabPostInit("iso_licking", IcanTALK)
AddPrefabPostInit("tpg_licking", IcanTALK)

local licking_eyebone = GLOBAL.Recipe("licking_eyebone",{ Ingredient("goldnugget", 2), Ingredient("boards", 2),  Ingredient("nightmarefuel", 2),},                     
	RECIPETABS.SCIENCE, TECH.NONE )
licking_eyebone.atlas = "images/inventoryimages/licking_eyebone.xml"

local iso_licking_eyebone = GLOBAL.Recipe("iso_licking_eyebone",{ Ingredient("goldnugget", 2), Ingredient("boards", 2),  Ingredient("nightmarefuel", 2),},        
	RECIPETABS.SCIENCE, TECH.NONE )
iso_licking_eyebone.atlas = "images/inventoryimages/iso_licking_eyebone.xml"

local tpg_licking_eyebone = GLOBAL.Recipe("tpg_licking_eyebone",{ Ingredient("goldnugget", 4), Ingredient("boards", 4),  Ingredient("nightmarefuel", 3),},        
	RECIPETABS.SCIENCE, TECH.NONE )
tpg_licking_eyebone.atlas = "images/inventoryimages/tpg_licking_eyebone.xml"


-- ****************
-- Books of Licking
-- ****************
local LickingBadge = GLOBAL.require "widgets/lickingsbadge"
local function UpdStatusDisplay(inst)
	local LickingBadge = GLOBAL.require "widgets/lickingsbadge"
	inst.ltrust = inst:AddChild(LickingBadge(GetPlayer())) --GetPlayer() or owner
	inst.ltrust:SetPosition(0,-185,0)
end
AddClassPostConstruct("widgets/statusdisplays", UpdStatusDisplay)

-- PostInit For All custom characters and default characters
local function G_BuildCraftTab(tab)

	local blessing_licking = GLOBAL.Recipe("blessing_licking", {Ingredient("papyrus", 3), Ingredient("trunk_summer", 2),}, tab, GLOBAL.TECH.NONE)
	blessing_licking.atlas = "images/inventoryimages/blessing_licking.xml"
	local licking_help = GLOBAL.Recipe("licking_help", {Ingredient("papyrus", 3), Ingredient("meat", 2), Ingredient("goldnugget", 1),}, tab, GLOBAL.TECH.NONE)
	licking_help.atlas = "images/inventoryimages/licking_help.xml"
	local lickings_pelt = GLOBAL.Recipe("lickings_pelt", {Ingredient("papyrus", 3), Ingredient("rope", 2), Ingredient("nightmarefuel", 2),}, tab, GLOBAL.TECH.NONE)
	lickings_pelt.atlas = "images/inventoryimages/book_licking.xml"
	
	return tab
end

AddPlayersPostInit(function(inst)
    inst:AddComponent("reader")
	inst:AddComponent("talker")
	local GLibrary = {str = "Literature of Lickings", sort=96, icon = "lickings_tab.tex", icon_atlas = "images/lickings_tab.xml"}
	inst.components.builder:AddRecipeTab(GLibrary)
	G_BuildCraftTab(GLibrary)
end)