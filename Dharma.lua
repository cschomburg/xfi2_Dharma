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

Dharma = Dharma or {}

--[[*****************************
	1. Core Functions
********************************]]

local closed
local touchDown, homeDown, powerDown
local lX, lY, x, y

local widgets, classes = {}, {}

function Dharma.NewClass(name, parent)
	parent = type(parent) == "string" and classes[parent] or parent
	local prototype = parent and setmetatable({}, parent) or {}
	prototype.__index = prototype
	prototype._parent = parent or Dharma
	classes[name] = prototype
	return prototype
end

function Dharma.New(name, ...)
	local class = classes[name]
	local widget = setmetatable({}, class)
	return widget:_new(...)
end

-- Exit the event loop
function Dharma.Exit()
	closed = true
end

-- Returns if the touchscreen is pressed
function Dharma.IsTouchDown()
	return touchDown
end

-- Returns if the home button is pressed
function Dharma.IsHomeDown()
	return homeDown
end

-- Returns if the power button is pressed
function Dharma.IsPowerDown()
	return powerDown
end

function Dharma.GetLastTouchPos()
	return lX, lY
end

--[[*****************************
	2. Event Processing Loop
********************************]]

local function safeCall(tbl, event, ...)
	return tbl[event] and tbl[event](tbl, ...)
end

local function touchEvent()
	lX, lY, x, y = x, y, touch.pos()
	for i = #widgets, 1, -1 do
		local widget = widgets[i]
		if widget.touchEnabled and not widget.hidden and widget:Contains(x, y) then
			if touch.up() == 1 then
				safeCall(widget, "OnTouchUp", x, y)
				tDown = nil
			elseif touch.down() == 1 then
				safeCall(widget, "OnTouchDown", x, y)
				tDown = true
			elseif touch.hold() == 1 then
				safeCall(widget, "OnTouchHold", x, y)
			elseif touch.move() == 1 then
				safeCall(widget, "OnTouchMove", x, y)
			elseif touch.click() == 1 then
				safeCall(widget, "OnTouchClick", x, y)
			end
			return true
		end
	end
end

local function buttonEvent()
	if(not Dharma.Focus) then return end
	local focus = Dharma.Focus
	
	if button.click() == 1 then
		if button.home() == 1 then
			homeDown = nil
			safeCall(focus, "OnHomeClick")
		elseif button.power() == 1 then
			powerDown = nil
			safeCall(focus, "OnPowerClick")
		end
	elseif button.up() == 1 then
		if button.home() == 1 then
			homeDown = nil
			safeCall(focus, "OnHomeUp")
		elseif button.power() == 1 then
			powerDown = nil
			safeCall(focus, "OnPowerUp")
		end
	elseif button.hold() then
		if button.home() == 1 then
			if homeDown then
				safeCall(focus, "OnHomeHold")
			else
				homeDown = true
				safeCall(focus, "OnHomeDown")
			end
		elseif button.power() == 1 and not powerDown then
			if powerDown then
				safeCall(focus, "OnPowerHold")
			else
				powerDown = true
				safeCall(focus, "OnPowerDown")
			end
		end
	end
end

local function sensorEvent()
	-- Placeholder
end

-- Start the event loop
function Dharma.Loop(wait)
	Dharma.screenUpdate = true
	repeat

		-- Event checks
		if control.read(wait == true and 1 or nil) == 1 then
			if control.isButton() == 1 then
				buttonEvent()
			elseif control.isTouch() == 1 then
				touchEvent()
			elseif control.isSensor() == 1 then
				sensorEvent()
			end
		end

		if Dharma.screenUpdate then
			Dharma.screenUpdate = nil

			-- Call OnUpdate routines for drawing
			for i, widget in pairs(widgets) do
				if not widget.hidden then
					safeCall(widget, "_draw")
					safeCall(widget, "OnDraw")
				end
			end
			
			-- Send framebuffer
			screen.update()
		end
		if(wait and wait ~= true) then os.wait(wait) end
	until closed
end

Dharma.Widgets, Dharma.Classes = widgets, classes
Dharma.Focus = Dharma
Dharma.OnHomeClick = Dharma.Exit