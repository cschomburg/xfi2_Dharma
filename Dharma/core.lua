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

Dharma = Dharma or {}

local dharmaFiles = {
	Colors = "colors",
	Data = "data",
	KeyBoard = "widgets/w_Keyboard",
	Profiler = "profiler",

	Widget = "widgets/widget",
	Button = "widgets/w_button",
	CheckBox = "widgets/w_checkbox",
	Debug = "widgets/debug",
	Image = "widgets/w_image",
	KeyBoard = "widgets/w_keyboard",
	Slider = "widgets/w_slider",
	Text = "widgets/w_text",
	TextBox = "widgets/w_textbox",
}

local classes = {}

mt_load = {__index = function(self, name)
	if(dharmaFiles[name]) then
		require("Dharma/"..dharmaFiles[name])
		return rawget(self, name)
	end
end}

setmetatable(Dharma, mt_load)
setmetatable(classes, mt_load)

--[[!
	@fn prototype = Dharma.NewClass(name [, parent])
	Creates a new class prototype, inheriting from class 'parent'
	@param name The name of the new class
	@param parent The parent class from which functions will be inherited [optional]
	@return prototype The basis of the new class
--]]
function Dharma.NewClass(name, parent)
	parent = parent and classes[parent]

	local prototype = parent and setmetatable({}, parent) or {}
	prototype.__index = prototype
	prototype.class = name
	classes[name] = prototype
	return prototype
end

--[[!
	@fn instance = Dharma.New(name [, ...])
	Creates an instance of the class 'name'.
	@param name The name of the class
	@param ... Additional options passed to the constructor [optional]
	@return instance The newly created instance
]]
function Dharma.New(name, ...)
	local class = classes[name]
	local instance = setmetatable({}, class)
	instance:_new(...)
	return instance
end

--[[!
	@fn bool = Dharma.IsClass(object, name)
	Checks whether the instance inherits functions from the class 'name'
	@param object The instance which is checked
	@param name The class name
]]
function Dharma.IsClass(object, name)
	while(true) do
		if(not object or not object.class) then return end
		if(object.class == class) then return true end
		object = getmetatable(object)
	end
end

--[[!
	@fn color = Dharma.Color(colorString)
	@overload color = Dharma.Color(color)
	Returns a color object representing the parameters
	@param colorString a color name
	@param color a color-table
	@return color the resulting color-table
]]
function Dharma.Color(r,g,b,a)
	if(type(r) == "string") then
		return Dharma.Colors[r]
	else
		return r
	end
end

--[[!
	@fn bool = Dharma.IsZen()
	Returns whether the environment is a real Zen or a simulator
]]
local isZen = debug.traceback():match("a:/")
function Dharma.IsZen()
	return isZen
end

Dharma.clock = Dharma.IsZen() and os.ostime or os.clock
Dharma.Classes = classes