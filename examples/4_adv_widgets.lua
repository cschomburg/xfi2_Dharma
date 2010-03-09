--[[
	This example Dharma app creates:
	- a movable button which closes the application
	- a slider which can be dragged
	- a text to show the slider's position

	It also remembers all settings until the next start!
]]

-- Load the Dharma core
require "Dharma/core"

-- Create our main application, serving as the background
local app = Dharma.New("Widget", "black")

-- Our initial values
-- they will be remembered after exit and
-- restored when starting the application again
local dataBase = Dharma.Data.Get("adv_widgets", {
	x = 50, -- position of the movable button
	y = 50, -- position of the movable button
	value = 70, -- value of the slider
})

-- Create the button, with text "Move me!"
local button = app:New("Button", "Move me!")
button:SetPos(dataBase.x, dataBase.y) -- Set the position ...
button:SetSize(120, 35) -- ... and the size

-- Event: Move the button to our finger position
function button:OnTouchMove(x, y)
	button:SetPos(x-self.width/2, y-self.height/2)
end

-- Event: Close the app
function button:OnTouchClick()
	app:Exit()
end

-- Create the slider
local slider = app:New("Slider")
slider:SetPos(50, 120) -- position
slider:SetSize(200, 20) -- size
slider:SetBackgroundColor(color.new(50, 50, 50)) -- dark gray as background color
slider:SetMinMaxValues(0, 100) -- values go from 0 to 100
slider:EnableTouch(true, true) -- enable touch, so we can drag it

-- Create the text
local text = app:New("Text")
text:SetPoint("left", slider, "right", 10, 0) -- Move the left edge of the text to the right edge of the slider

-- Event: Update the text when the slider's value changes
function slider:OnValueChanged(value)
	text:SetFormattedText("%.0f", value)
end

slider:SetValue(dataBase.value) -- setup the initial value

-- Start the application loop
app:Loop(10)

dataBase.x = button.x
dataBase.y = button.y
dataBase.value = slider.value
Dharma.Data.Save("adv_widgets")