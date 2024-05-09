require "util"
local Screen = require "widgets/screen"
local Button = require "widgets/button"
local AnimButton = require "widgets/animbutton"
local ImageButton = require "widgets/imagebutton"
local Menu = require "widgets/menu"
local Grid = require "widgets/grid"
local Text = require "widgets/text"
local Image = require "widgets/image"
local UIAnim = require "widgets/uianim"
local Spinner = require "widgets/spinner"
local NumericSpinner = require "widgets/numericspinner"
local Widget = require "widgets/widget"
local text_font = UIFONT --NUMBERFONT
local enableDisableOptions = { { text = STRINGS.UI.OPTIONS.DISABLED, data = false }, { text = STRINGS.UI.OPTIONS.ENABLED, data = true } }
local spinnerFont = { font = BUTTONFONT, size = 30 }

LickingSettings = Class(Screen, function(self, in_game)
	Screen._ctor(self, "LickingSettings")
	SetPause(true)
	self.in_game = in_game
	
--Настройки
	self.options = {
		Following = Profile:GetValue("following"),
		CantDie = Profile:GetValue("lickingcantdie"),
		Fridge = Profile:GetValue("fridge"),
	}

	self.working = deepcopy( self.options )
    self.black = self:AddChild(Image("images/global.xml", "square.tex"))
    self.black:SetVRegPoint(ANCHOR_MIDDLE)
    self.black:SetHRegPoint(ANCHOR_MIDDLE)
    self.black:SetVAnchor(ANCHOR_MIDDLE)
    self.black:SetHAnchor(ANCHOR_MIDDLE)
    self.black:SetScaleMode(SCALEMODE_FILLSCREEN)
	self.black:SetTint(0,0,0,.25)	
	self.root = self:AddChild(Widget("ROOT"))
    self.root:SetVAnchor(ANCHOR_MIDDLE)
    self.root:SetHAnchor(ANCHOR_MIDDLE)
    self.root:SetPosition(0,0,0)
    self.root:SetScaleMode(SCALEMODE_PROPORTIONAL)
    
	local shield = self.root:AddChild( Image( "images/globalpanels.xml", "panel.tex" ) )
	shield:SetPosition( 0,0,0 )
	shield:SetSize( 520, 400 ) --размер заднего фона
	
	self.menu = self.root:AddChild(Menu(nil, -60, false))
	self.menu:SetPosition(120 , -130 ,0) --(240 , -220 ,0) //позиция меню

	self.grid = self.root:AddChild(Grid())
	self.grid:InitSize(2, 7, 200, -70) --(2, 7, 200, -70)
	self.grid:SetPosition(0, 115, 0) --(-250, 175, 0) //позиция настроек
	self:DoInit()
	self:InitializeSpinners()

	self.default_focus = self.menu

end)

function LickingSettings:Accept()
	self.options = deepcopy( self.working )
--Настройки		
	Profile:SetValue("following", self.options.Following)
	Profile:SetValue("lickingcantdie", self.options.CantDie)
	Profile:SetValue("fridge", self.options.Fridge)
	
	Profile:Save()
	
	TheFrontEnd:PopScreen()
	SetPause(false)
end

local function MakeMenu(offset, menuitems)
	local menu = Widget("OptionsMenu")	
	local pos = Vector3(0,0,0)
	for k,v in ipairs(menuitems) do
		local button = menu:AddChild(ImageButton())
	    button:SetPosition(pos)
	    button:SetText(v.text)
	    button.text:SetColour(0,0,0,1)
	    button:SetOnClick( v.cb )
	    button:SetFont(BUTTONFONT)
	    button:SetTextSize(40)    
	    pos = pos + offset  
	end
	return menu
end

function LickingSettings:CreateSpinnerGroup( text, spinner )
--Настройка кнопок
	local label_width = 210 --200
	spinner:SetTextColour(0,0,0,1)
	local group = Widget( "SpinnerGroup" )
	local label = group:AddChild( Text( BODYTEXTFONT, 30, text ) )
	label:SetPosition( -label_width/2, 0, 0 )
	label:SetRegionSize( label_width+25, 50 ) --50
	label:SetHAlign( ANCHOR_LEFT )
	
	group:AddChild( spinner )
	spinner:SetPosition( 127, 0, 0 ) --( 125, 0, 0 ) //позиция выбора настроек относительно имени настройки
	group.focus_forward = spinner
	return group
end

function LickingSettings:UpdateMenu()
	self.menu:Clear()
	self.menu:AddItem(STRINGS.UI.OPTIONS.CLOSE, function() self:Accept() end)
end

function LickingSettings:DoInit()
	self:UpdateMenu()

	local this = self

--Настройки	
	self.FollowingSpinner = Spinner( enableDisableOptions )
	self.FollowingSpinner.OnChanged =
		function( _, data )
			this.working.Following = data
			self:UpdateMenu()
		end
		
	self.CantDieSpinner = Spinner( enableDisableOptions )
	self.CantDieSpinner.OnChanged =
		function( _, data )
			this.working.CantDie = data
			self:UpdateMenu()
		end
	
	self.FriedgeSpinner = Spinner( enableDisableOptions )
	self.FriedgeSpinner.OnChanged =
		function( _, data )
			this.working.Fridge = data
			self:UpdateMenu()
		end
		
--Интерфейс
	local central_spinners = {}
	table.insert( central_spinners, { "Lickings stop defend you", self.FollowingSpinner } )
	table.insert( central_spinners, { "Lickings cant die", self.CantDieSpinner } )
	table.insert( central_spinners, { "Iso-licking work as fridge", self.FriedgeSpinner } )

	self.grid:InitSize(2, 7, 400, -70) --(2, 7, 400, -70)

	for k,v in ipairs(central_spinners) do
		self.grid:AddItem(self:CreateSpinnerGroup(v[1], v[2]), 1, k)	
	end

end

local function EnabledOptionsIndex( enabled )
	if enabled then
		return 2
	else
		return 1
	end
end

function LickingSettings:InitializeSpinners()

--Настройки	
	self.FollowingSpinner:SetSelectedIndex( EnabledOptionsIndex( self.working.Following ) )
	self.CantDieSpinner:SetSelectedIndex( EnabledOptionsIndex( self.working.CantDie ) )
	self.FriedgeSpinner:SetSelectedIndex( EnabledOptionsIndex( self.working.Fridge ) )
end