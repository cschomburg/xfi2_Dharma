--[[
	This example Dharma app creates 100 transparent boxes,
	each randomly positioned, colored and sized.
	You can also drag them around.

	Dharma initially sets the Home-button to exit,
	so no worries that you won't get out of the app ;)
]]

-- Loading Dharma
require "Dharma/core"

-- Seeding our random function
math.randomseed(os.time())

-- Setting up all colors in a table
local colors = {
	color.new(255, 0, 0, 180),
	color.new(0, 255, 0, 180),
	color.new(0, 0, 255, 180),
	color.new(255, 255, 0, 180),
	color.new(0, 255, 255, 180),
	color.new(255, 0, 255, 180),
	color.new(255, 255, 255, 180),
}

-- Making a dark gray background
local Application = Dharma.New("Widget", color.new(50, 50, 50))

-- Now we create our box-class
local MovableBox = Dharma.NewClass("MovableBox", "Text")
MovableBox:EnableTouch(true, true) -- We want to have them touch-enabled
MovableBox:SetBorderColor("black")

-- Every time the user moves a box,
-- we adjust the position of the box
function MovableBox:OnTouchMove(x, y)
	self:SetPos(x-self.width/2, y-self.height/2)
end

-- Now we spawn the 100 boxes!
for i=1, 100 do
	local box = Application:New("MovableBox")

	local color = colors[math.random(1, #colors)]
	local size = math.random(5, 20)
	local x, y = math.random(0, screen.width()), math.random(0, screen.height())

	box:SetText(i)
	box:SetBackgroundColor(color)
	box:SetSize(size)
	box:SetPos(x, y)
end

-- Ready for action!
Application:Loop(10)