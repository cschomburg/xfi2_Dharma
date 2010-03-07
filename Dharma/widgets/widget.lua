--[[!

	@name		Dharma
	@author		Constantin Schomburg <xconstruct@gmail.com>
	@version	0.1

	@section DESCRIPTION

	Dharma is a framework for Creative Zen X-Fi 2 Applications.
	The core introduces methods for creating OOP classes and
	handles loading of additional files, including the GUI widgets.

	@section LICENSE

    Dharma: A Framework for Creative Zen X-Fi 2 Applications

    Copyright (C) 2010  Constantin Schomburg <xconstruct@gmail.com>

    This file is part of Dharma.

    Dharma is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 2 of the License, or
    (at your option) any later version.

    Dharma is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Dharma.  If not, see <http://www.gnu.org/licenses/>.
]]

--[[!
	@class Widget
	The base of all Dharma Widgets

	@var x The relative x-coordinate of the topleft corner [default: 0]
	@var y The relative y-coordinate of the topleft corner [default: 0]
	@var width The width of the widget [default: screen-width]
	@var height The height of the widget [default: screen-height]

	@callback OnThink(waitTime) On every update
	@callback OnDraw() A redrawing of the widget is needed
	@callback OnTouchDown(x, y) The user touches the touchscreen
	@callback OnTouchClick(x, y) The user clicks the touchscreen
	@callback OnTouchHold(x, y) The user holds the touchscreen
	@callback OnTouchMove(x, y) The user moves on the touchscreen
	@callback OnTouchUp(x, y) The user releases the touchscreen
]]

local Widget = Dharma.NewClass("Widget")

Widget.x = 0
Widget.y = 0
Widget.width = screen.width()
Widget.height = screen.height()

--[[!
	@fn Widget:_new([color])
	The constructor of the class
	@param color Either a colorString or color-table [optional]
]]
function Widget:_new(color)
	self.bgColor = Dharma.Color(color)
	self.children = {self}
end

--[[!
	@fn bool = Widget:IsClass(name)
	Checks if the widget inherits functions from the class 'name'
	@param name The name of the class
	@return bool Boolean holding the result
]]
Widget.IsClass = Dharma.IsClass

--[[!
	@fn widget = Widget:New(name [, ...])
	Creates a new instance of class 'name' as a child of this widget
	@param name The name of the class
	@param ... additional arguments passed to the constructor [optional]
	@return widget The new widget
]]
function Widget:New(name, ...)
	local widget = Dharma.New(name, ...)
	widget:SetParent(self)
	self.children[#self.children+1] = widget
	return widget
end

--[[!
	@fn bool = Widget:Contains(x, y)
	Checks whether the widget contains the coordinates
	@param x An absolute x-coordinate
	@param y An absolute y-coordinate
]]
function Widget:Contains(x, y)
	local wX, wY = self:GetScreenPos()
	return (x >= wX) and (x <= wX + self.width) and (y >= wY) and (y <= wY + self.height)
end

--[[!
	@fn bool = Widget:Intersects(widget)
	Checks whether the widget intersects with another one
	@param widget The other widget
]]
function Widget:Intersects(widget)
	local x, y = self:GetScreenPos()
	local wX, wY = widget:GetScreenPos()
	return (x < wX + widget.width) and (wX < x + self.width) and (y < wY + widget.height) and (wY < y + self.height)
end

--[[!
	@fn Widget:SetParent(parent)
	Set the parent of the widget to another widget
	@param parent another widget serving as the parent
]]
function Widget:SetParent(parent)
	local oldParent = self.parent

	if(self.parent) then
		for k, v in pairs(self.parent.children) do
			if(v == self) then
				tremove(self.parent.children, k)
				break
			end
		end
	end

	self.parent = parent
	self:UpdateScreen()
end

--[[!
	@fn Widget:EnableTouch(touch [, focus])
	Enables touch callbacks for this widget
	@param touch Boolean for enabling touch events
	@param focus Boolean for receiving events when not hovered, but focused [optional]
]]
function Widget:EnableTouch(touch, focus)
	self.touchEnabled, self.focusEnabled = touch, focus
end

--[[!
	@fn Widget:SetHidden(flag)
	Hide this widget, stopping touchscreen interaction and redrawing
	@param flag Boolean for toggling
]]
function Widget:SetHidden(flag)
	self.hidden = flag
	self:UpdateScreen()
end

--[[!
	@fn bool = Widget:IsHidden()
	Checks whether the widget or its parent is hidden
]]
function Widget:IsHidden()
	return self.hidden or (self.parent and self.parent:IsHidden())
end

--[[!
	@fn Widget:SetSize(width, height)
	@overload Widget:SetSize(size)
	Sets the width and height of the widget
	@param width Number holding new width
	@param height Number holding new height
	@param size Number holding new width and height
]]
function Widget:SetSize(width, height)
	self.width, self.height = width, height or width
	self:UpdateScreen()
end

--[[!
	@fn Widget:SetPos(x, y)
	Sets the position of the widget, relative to its parent
	@param x The relative x-coordinate of the topleft corner
	@param y The relative y-coordinate of the topleft corner
]]
function Widget:SetPos(x, y)
	self.x, self.y = x, y
	self:UpdateScreen()
end

--[[!
	@fn x, y = Widget:GetScreenPos()
	Returns the absolute position of the widget
	@return x The absolute x-coordinate of the topleft corner
	@return y The absolute y-coordinate of the topleft corner
]]
function Widget:GetScreenPos()
	if(not self.parent) then return self.x, self.y end
	local x, y = self.parent:GetScreenPos()
	return self.x + x, self.y + y
end

--[[!
	@fn Widget:OnDraw()
	Draws the widget's background and border
]]
function Widget:OnDraw()
	local x, y = self:GetScreenPos()
	if(self.borderColor) then
		screen.drawrect(x-1, y-1, x+self.width, y+self.height, self.borderColor)
	end
	if(self.bgColor) then
		screen.fillrect(x, y, self.width, self.height, self.bgColor)
	end
end

--[[!
	@fn Widget:SetBackgroundColor(color)
	Sets the background color of the widget
	@param color Either a colorString or color-table
]]
function Widget:SetBackgroundColor(color)
	self.bgColor = Dharma.Color(color)
	self:UpdateScreen()
end

--[[!
	@fn Widget:SetBorderColor(color)
	Sets the border color of the widget
	@param color Either a colorString or color-table
]]
function Widget:SetBorderColor(...)
	self.borderColor = Dharma.Color(...)
	self:UpdateScreen()
end





--[[*****************************
	2. Event Processing Loop
********************************]]
local screenUpdate
local touchDown, homeDown, powerDown
local lX, lY, x, y

local function safeCall(tbl, event, ...)
	return tbl[event] and tbl[event](tbl, ...)
end

local function touchEvent(self)
	if(self.touchEnabled and (tDown == self or self:Contains(x, y))) then
		if(touch.up() == 1) then
			tDown = nil
			safeCall(self, "OnTouchUp", x, y)
		elseif(touch.down() == 1) then
			tDown = self
			safeCall(self, "OnTouchDown", x, y)
		elseif(touch.hold() == 1) then
			safeCall(self, "OnTouchHold", x, y)
		elseif(touch.move() == 1) then
			safeCall(self, "OnTouchMove", x, y)
		elseif(touch.click() == 1) then
			tDown = nil
			safeCall(self, "OnTouchClick", x, y)
		end
		return true
	end
end


local function applyFuncRecursive(self, inverse, func, ...)
	if(self.hidden) then return end

	for i = inverse and #self.children or 1, inverse and 1 or #self.children, inverse and -1 or 1 do
		local widget = self.children[i]
		if(widget == self) then
			if(func(self, ...)) then return true end
		else
			if(applyFuncRecursive(widget, inverse, func, ...)) then return true end
		end
	end
end

local function buttonEvent(self)
	local focus = self.focus or self
	
	if(button.click() == 1) then
		if(button.home() == 1) then
			homeDown = nil
			safeCall(focus, "OnHomeClick")
		elseif(button.power() == 1) then
			powerDown = nil
			safeCall(focus, "OnPowerClick")
		end
	elseif(button.up() == 1) then
		if(button.home() == 1) then
			homeDown = nil
			safeCall(focus, "OnHomeUp")
		elseif(button.power() == 1) then
			powerDown = nil
			safeCall(focus, "OnPowerUp")
		end
	elseif(button.hold()) then
		if(button.home() == 1) then
			if(homeDown) then
				safeCall(focus, "OnHomeHold")
			else
				homeDown = true
				safeCall(focus, "OnHomeDown")
			end
		elseif(button.power() == 1 and not powerDown) then
			if(powerDown) then
				safeCall(focus, "OnPowerHold")
			else
				powerDown = true
				safeCall(focus, "OnPowerDown")
			end
		end
	end
end

local function sensorEvent(self)
	-- Placeholder
end

local function handleEvents(self)
	if(control.isButton() == 1) then
		buttonEvent(self)
	elseif(control.isTouch() == 1) then
		lX, lY, x, y = x, y, touch.pos()
		if(tDown) then
			touchEvent(tDown)
		else
			applyFuncRecursive(self, true, touchEvent)
		end
	elseif(control.isSensor() == 1) then
		sensorEvent(self)
	end
end

local calcNum, lastCalc, clock = 0

--[[!
	@fn Widget:Loop([waitTime])
	Starts the loop, processing events/callbacks and redrawing frames
	@param waitTime The amount of milliseconds to wait before the next iteration [optional]
]]
function Widget:Loop(waitTime)
	tDown = nil
	screenUpdate = true
	repeat

		if(os.time() ~= clock) then
			clock = os.time()
			lastCalc, calcNum = calcNum, 0
		end

		if(not screenUpdate) then
			if(waitTime) then
				while(control.read() == 1) do
					handleEvents(self)
				end
			elseif(control.read(1) == 1) then
				handleEvents(self)
			end
		end

		applyFuncRecursive(self, nil, safeCall, "OnThink", waitTime)

		if(screenUpdate) then
			calcNum = calcNum + 1
			applyFuncRecursive(self, nil, safeCall, "OnDraw")
			screenUpdate = nil
			screen.update()
		end
		if(waitTime) then os.wait(waitTime) end
	until self.closed
	screenUpdate = true
	self.closed = nil
	safeCall(self, "OnExit")
end

--[[!
	@fn fps = Widget:GetFPS()
	Returns an approximation of the frames per second
	@result fps Number holding the frames per second
]]
function Widget:GetFPS()
	return lastCalc
end

--[[!
	@fn Widget:Exit()
	Exit the loop on the next iteration
]]
function Widget:Exit()
	self.closed = true
end

--[[!
	@fn Widget:UpdateScreen()
	Schedule a redrawing of the screen on the next iteration
]]
function Widget:UpdateScreen()
	screenUpdate = true
end

--[[!
	@fn bool = Widget:IsTouchDown()
	Returns whether the user currently presses the touchscreen
]]
function Widget.IsTouchDown()
	return touchDown
end

--[[!
	@fn bool = Widget:IsHomeDown()
	Returns whether the user currently presses the home key
]]
function Widget:IsHomeDown()
	return homeDown
end

--[[!
	@fn bool = Widget:IsPowerDown()
	Returns whether the user currently presses the power key
]]
function Widget:IsPowerDown()
	return powerDown
end

--[[!
	@fn x, y = Widget:GetLastTouchPos()
	Returns the last touchscreen coordinate of the user
	@return x The x-coordinate
	@return y The y-coordinate
]]
function Widget:GetLastTouchPos()
	return lX, lY
end

Widget.OnHomeClick = Widget.Exit
Widget.OnPowerClick = function(self) Dharma.Debug.Toggle(self) end
Widget.Color = Dharma.Color
Widget.IsZen = Dharma.IsZen