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

require "Dharma"

--[[*****************************
	1. Widget
		The simplest of all Dharma Widgets
********************************]]

local Widget = Dharma.NewClass("Widget")

Widget.x = 0
Widget.y = 0
Widget.width = screen.width()
Widget.height = screen.height()

function Widget:_new()
	table.insert(Dharma.Widgets, self)
	return widget
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

function Widget:EnableTouch(flag)
	self.touchEnabled = flag
end

function Widget:SetHidden(flag)
	Widget.hidden = flag
	Dharma.screenUpdate = true
end

function Widget:SetDimensions(x, y, height, width)
	self.x, self.y, self.width, self.height = x, y, height, width or height
	Dharma.screenUpdate = true
end

function Widget:SetSize(height, width)
	self.height, self.width = height, width or height
	Dharma.screenUpdate = true
end

function Widget:SetPos(x, y)
	self.x, self.y = x, y
	Dharma.screenUpdate = true
end



--[[*****************************
	2. Box
		A widget with a static background color
********************************]]

local Box = Dharma.NewClass("Box", "Widget")

function Box:_draw()
	if self.bgColor then
		screen.fillrect(self.x, self.y, self.width, self.height, self.bgColor)
	end
end

function Box:_new(color)
	self._parent._new(self)
	self.bgColor = color
	return self
end

--[[*****************************
	3. Image
		A widget which displays a static image
********************************]]

local Image = Dharma.NewClass("Image", "Widget")

function Image:_draw()
	if self.image then
		self.image:draw(self.x, self.y, self.width, self.height)
	end
end

function Image:_new(path)
	self._parent._new(self)
	if path then self.image = image.load(path) end
	return self
end

--[[*****************************
	3. Text
		A widget which displays text
********************************]]

local Text = Dharma.NewClass("Text", "Widget")
Text.size = 20
Text.color = color.new(255, 255, 255)
Text.align = "left"

function Text:_draw()
	if self.text then
		text.color(self.color)
		text.size(self.size)
		text.draw(self.x, self.y, self.text, self.align, self.width)
	end
end

function Text:_new(msg, size, color, align)
	self._parent._new(self)
	self.text, self.size, self.color, self.align = msg, size, color, align
	return self
end

function Text:SetText(msg, r,g,b,a)
	if(r and g and b) then
		self.color = color.new(r,g,b, a)
	end
	self.text = msg
	Dharma.screenUpdate = true
end

function Text:SetFormattedText(msg, ...)
	self:SetText(msg:format(...))
end