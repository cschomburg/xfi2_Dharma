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

function Widget:_new()
	table.insert(Dharma.Widgets, self)
	return widget
end

function Widget:Destroy()
	for k, v in pairs(Dharma.Widgets) do
		if(v == self) then
			return tremove(Dharma.Widgets, k)
		end
	end
end

function Widget:Contains(x, y)
	return (x >= self.x) and (x <= self.x + self.width) and (y >= self.y) and (y <= self.y + self.height)
end

function Widget:Intersects(widget)
	return (self.x < widget.x + widget.width) and (widget.x < self.x + self.width) and (self.y < widget.y + widget.width) and (self.y + self.width < self.y)
end

function Widget:GrabButtons()
	Dharma.Focus = self
end

function Widget:EnableTouch(touch, focus)
	self.touchEnabled, self.focusEnabled = touch, focus
end

function Widget:SetHidden(flag)
	Widget.hidden = flag
	Dharma.screenUpdate = true
end

function Widget:SetSize(width, height)
	self.width, self.height = width, height or width
	Dharma.screenUpdate = true
end

function Widget:SetPos(x, y)
	self.x, self.y = x, y
	Dharma.screenUpdate = true
end