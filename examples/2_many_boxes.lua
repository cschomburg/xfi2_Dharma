--[[
	This example Dharma app creates 100 transparent boxes,
	each randomly positioned, colored and sized.
	You can also drag them around.

	Their position will be saved in "boxes.data.lua"
	and restored when you start the application again

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

-- Initialize our database
local dataBase, isNew = Dharma.Data.Get("boxes")

-- No database found?
-- Setup random 100 boxes
if(isNew) then
	for i=1, 100 do
		local boxData = {}
		boxData.color = math.random(1, #colors)
		boxData.size = math.random(5, 20)
		boxData.x = math.random(0, screen.width())
		boxData.y = math.random(0, screen.height())
		table.insert(dataBase, boxData)
	end
end

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

local boxes = {}

-- Now we spawn the 100 boxes!
for i, boxData in ipairs(dataBase) do
	local box = Application:New("MovableBox")
	box:SetText(i)
	box:SetBackgroundColor(colors[boxData.color])
	box:SetSize(boxData.size)
	box:SetPos(boxData.x, boxData.y)
	table.insert(boxes, box)
end

-- Save box positions on exit
function Application:OnExit()
	for i, boxData in ipairs(dataBase) do
		boxData.x = boxes[i].x
		boxData.y = boxes[i].y
	end
	Dharma.Data.Save("boxes")
end

-- Ready for action!
Application:Loop(10)