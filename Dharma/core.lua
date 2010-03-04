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

local dharmaFiles = {
	Debug = "debug",
	Profiler = "profiler",
	Colors = "colors",

	Widget = "widget",
	Image = "w_image",
	Text = "w_text",
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

function Dharma.NewClass(name, parent)
	parent = classes[parent]

	local prototype = parent and setmetatable({}, parent) or {}
	prototype.__index = prototype
	prototype.class = name
	classes[name] = prototype
	return prototype
end

function Dharma.New(name, ...)
	local class = classes[name]
	local widget = setmetatable({}, class)
	widget:_new(...)
	return widget
end

function Dharma.IsClass(object, name)
	while(true) do
		if(not object or not object.class) then return end
		if(object.class == class) then return true end
		object = getmetatable(object)
	end
end

function Dharma.Color(r,g,b,a)
	if(r and g and b) then
		return a and color.new(r,g,b,a) or color.new(r,g,b)
	elseif(type(r) == "string") then
		return Dharma.Colors[r]
	else
		return r
	end
end

local isZen
function Dharma.IsZen()
	if(isZen == nil) then
		isZen = debug.traceback():match("a:/")
	end
	return isZen
end

Dharma.Classes = classes