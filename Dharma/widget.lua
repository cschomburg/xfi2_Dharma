--[[

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

--[[*****************************
	1. Widget
		The simplest of all Dharma Widgets
********************************]]

local Widget = Dharma.NewClass("Widget")

Widget.x = 0
Widget.y = 0
Widget.width = screen.width()
Widget.height = screen.height()

Widget.IsClass = Dharma.IsClass

function Widget:_new(...)
	self.bgColor = Dharma.Color(...)
	self.children = {self}
end

function Widget:New(...)
	local widget = Dharma.New(...)
	widget:SetParent(self)
	self.children[#self.children+1] = widget
	return widget
end

function Widget:Contains(x, y)
	local wX, wY = self:GetScreenPos()
	return (x >= wX) and (x <= wX + self.width) and (y >= wY) and (y <= wY + self.height)
end

function Widget:Intersects(widget)
	local x, y = self:GetScreenPos()
	local wX, wY = widget:GetScreenPos()
	return (x < wX + widget.width) and (wX < x + self.width) and (y < wY + widget.height) and (wY < y + self.height)
end

function Widget:SetParent(parent)
	local oldParent = self.parent

	if(self.parent) then
		for k, v in pairs(self.parent.children) do
			if(v == self) then
				tremove(self.parent.children, k)
				break
			end
		end
		self.parent:UpdateScreen()
	end

	self.parent = parent
	if(parent) then parent:UpdateScreen() end
end

function Widget:EnableTouch(touch, focus)
	self.touchEnabled, self.focusEnabled = touch, focus
end

function Widget:SetHidden(flag)
	self.hidden = flag
	self:UpdateScreen()
end

function Widget:IsHidden()
	return self.hidden or (self.parent and self.parent:IsHidden())
end

function Widget:SetSize(width, height)
	self.width, self.height = width, height or width
	self:UpdateScreen()
end

function Widget:SetPos(x, y)
	self.x, self.y = x, y
	self:UpdateScreen()
end

function Widget:GetScreenPos()
	if(not self.parent) then return self.x, self.y end
	local x, y = self.parent:GetScreenPos()
	return self.x + x, self.y + y
end

function Widget:OnDraw()
	local x, y = self:GetScreenPos()
	if(self.borderColor) then
		screen.drawrect(x-1, y-1, x+self.width, y+self.height, self.borderColor)
	end
	if(self.bgColor) then
		screen.fillrect(x, y, self.width, self.height, self.bgColor)
	end
end

function Widget:SetBackgroundColor(...)
	self.bgColor = Dharma.Color(...)
	self:UpdateScreen()
end

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
			safeCall(self, "OnTouchUp", x, y)
			tDown = nil
		elseif(touch.down() == 1) then
			safeCall(self, "OnTouchDown", x, y)
			tDown = self
		elseif(touch.hold() == 1) then
			safeCall(self, "OnTouchHold", x, y)
		elseif(touch.move() == 1) then
			safeCall(self, "OnTouchMove", x, y)
		elseif(touch.click() == 1) then
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

local function loop(self, wait)
	screenUpdate = true
	repeat

		-- Event checks
		if(control.read(wait == true and 1 or nil) == 1) then
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

		applyFuncRecursive(self, nil, safeCall, "OnThink")

		if(screenUpdate) then
			applyFuncRecursive(self, nil, safeCall, "OnDraw")
			screenUpdate = nil
			screen.update()
		end
		if(wait and wait ~= true) then os.wait(wait) end
	until self.closed
	screenUpdate, self.closed = true
end

-- Start the event loop
function Widget:Loop(wait)
	local success, error = pcall(loop, self, wait)
	if(success) then return end
	Dharma.Console:Error(error)
end

-- Exit the event loop
function Widget:Exit()
	self.closed = true
end

function Widget:UpdateScreen()
	screenUpdate = true
end

function Widget.IsTouchDown()
	return touchDown
end

function Widget:IsHomeDown()
	return homeDown
end

function Widget:IsPowerDown()
	return powerDown
end

function Widget:GetLastTouchPos()
	return lX, lY
end

Widget.OnHomeClick = Widget.Exit
Widget.OnPowerClick = function() Dharma.Console:Loop(true) end