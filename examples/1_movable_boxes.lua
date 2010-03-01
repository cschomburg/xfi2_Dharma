--[[
	This example Dharma app creates two boxes.
	When you move them onto each other,
	both will be colored green.
]]

-- Loading Dharma
require "Dharma/core"

-- Making a dark gray background
local Application = Dharma.New("Widget", "black")

-- Now we create the class for our two boxes
local MovableBox = Dharma.NewClass("MovableBox", "Widget")
MovableBox:SetBackgroundColor("red")
MovableBox:EnableTouch(true, true) -- Make it touchable!
MovableBox:SetSize(50)

-- Let's create two of them
local box1 = Application:New("MovableBox")
local box2 = Application:New("MovableBox")

-- Display them on opposite sides
box1:SetPos(10, 80)
box2:SetPos(340, 80)

-- When the user moves one
function MovableBox:OnTouchMove(x, y)

	-- Update the position
	self:SetPos(x-self.width/2, y-self.height/2)

	-- Check for intersection
	if(box1:Intersects(box2)) then
		box1:SetBackgroundColor("lime")
		box2:SetBackgroundColor("lime")
	else
		box1:SetBackgroundColor()
		box2:SetBackgroundColor()
	end
end

-- Ready for action!
Application:Loop(10)