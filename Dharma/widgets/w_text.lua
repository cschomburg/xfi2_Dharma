--[[!

	@name		Dharma
	@author		Constantin Schomburg <xconstruct@gmail.com>
	@version	0.1

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
	@class Text
	@extends Widget
	Creates a simple text widget

	@var color The color-table of the text [default: white]
	@var align The align of the text [default: left]
	@var text The message to display
]]

local Text = Dharma.NewClass("Text", "Widget")
Text.color = color.new(255, 255, 255)
Text.align = "left"
Text.height = 20

--[[!
	Constructor function
	@param msg The message to display [optional]
	@param size The height of the widget [optional]
	@param color Either a color-table or colorString for the text-color [optional]
	@param align The align of the text [optional]
]]
function Text:_new(msg, size, color, align)
	Dharma.Classes.Widget._new(self)
	self.text, self.height, self.color, self.align = msg, size, Dharma.Color(color), align
end

--[[!
	@fn Text:OnDraw()
	Draws the text
]]
function Text:OnDraw()
	Dharma.Classes.Widget.OnDraw(self)
	if(self.text) then
		text.color(self.color)
		text.size(self.height)
		local x,y = self:GetScreenPos()
		text.draw(x, y, self.text, self.align, self.width)
	end
end

--[[!
	Sets the text and text color of the button
	@param text The caption of the button [optional]
	@param color Either a colorString or color-table for the text color [optional]
]]
function Text:SetText(msg, ...)
	self.color = Dharma.Color(...) or self.color
	self.text = msg
	self:UpdateScreen()
end

--[[!
	Sets the text by using string.format(format, ...)
	@param format The format string
	@param ... The arguments for format
]]
function Text:SetFormattedText(msg, ...)
	self:SetText(msg:format(...))
end

--[[!
	Sets the align of the text
	@param align The new align
]]
function Text:SetAlign(align)
	self.align = align
	self:UpdateScreen()
end

--[[!
	Sets the text color
	@param color Either a colorString or color-table for the text color
]]
function Text:SetColor(color)
	self.color = Dharma.Color(color)
	self:UpdateScreen()
end