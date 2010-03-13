--[[
	This example Dharma app creates:
	- an orange background
	- a movable slider
	- an editable text box which reflects the slider value
	- a button to set the current slider value

	It also remembers all settings until the next start!
]]

require "Dharma/core"

-- The background serving as our application
local app = Dharma.New("Widget", color.new(255, 128, 0))

-- The text box
local textbox = app:New("TextBox", "25.2")
textbox:SetSize(120, 20)
textbox:SetPos(130, 50)

-- The button
local button = app:New("Button", "Set Value")
button:SetPoint("left", textbox, "right", 10, 0)

-- and the slider
local slider = app:New("Slider")
slider:SetMinMaxValues(0, 100)
slider:SetValue(25.2)
slider:SetSize(230, 20)
slider:SetBorderColor(Dharma.Colors.black)
slider:SetBackgroundColor(color.new(0, 0, 0, 128))
slider:SetColor(color.new(0, 255, 255))
slider:SetPoint("topleft", textbox, "bottomleft", -5, 15)
slider:EnableTouch(true, true)

-- Update the text when the slider moves
function slider:OnValueChanged(value)
	textbox:SetFormattedText("%.1f", value)
end

-- Update the slider when the button is pressed
function button:OnTouchClick()
	slider:SetValue(tonumber(textbox.text) or 0)
end





-- An introductory text, with shadow!
local lineBox = app:New("Widget")
lineBox:SetBackgroundColor(color.new(0, 0, 0, 80))
lineBox:SetSize(270, 40)
lineBox:SetPos(120, 170)
lineBox:EnableTouch(true, true)

-- Yep, the box is movable!
function lineBox:OnTouchMove(x, y)
	self:SetPos(x-self.width/2, y-self.height/2)
end

-- The first line of text
local line1 = lineBox:New("Text", "You can drag the keyboard up or down", 13)
line1:SetPos(5, 5)
line1:SetShadow(Dharma.Colors.black, 1, 1)

-- The second line of text
local line2 = lineBox:New("Text", "to switch through keyboard layouts", 13)
line2:SetPoint("topleft", line1, "bottomleft", 5, 0)
line2:SetShadow(Dharma.Colors.black, 1, 1)

-- Start the loop
app:Loop(10)