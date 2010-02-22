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
	3. Text
		A widget which displays text
********************************]]

local Text = Dharma.NewClass("Text", "Widget")
Text.color = color.new(255, 255, 255)
Text.align = "left"
Text.height = 20

function Text:_draw()
	if self.text then
		text.color(self.color)
		text.size(self.height)
		text.draw(self.x, self.y, self.text, self.align, self.alignWidth)
	end
end

function Text:_new(msg, size, color, align)
	self._parent._new(self)
	self.text, self.size, self.color, self.align = msg, size, color, align
	return self
end

function Text:SetText(msg, ...)
	self.color = Dharma.Color(...) or self.color
	self.text = msg
	Dharma.screenUpdate = true
end

function Text:SetFormattedText(msg, ...)
	self:SetText(msg:format(...))
end

function Text:SetAlign(align)
	self.align = align
	Dharma.screenUpdate = true
end

function Text:SetColor(...)
	self.color = Dharma.Color(...)
	Dharma.screenUpdate = true
end