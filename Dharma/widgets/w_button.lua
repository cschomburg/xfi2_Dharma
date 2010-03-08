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
	@class Button
	@extends Widget
	Creates a clickable text button

	@var color The color of the text [default: white]
	@var text The displayed text
]]

local Button = Dharma.NewClass("Button", "Widget")
Button.color = color.new(255, 255, 255)
Button.width = 100
Button.height = 35

local btnLeft = image.load("Dharma/images/button-left.png")
local btnMiddle = image.load("Dharma/images/button-middle.png")
local btnRight = image.load("Dharma/images/button-right.png")

--[[!
	Constructor
	@param text The caption of the button [optional]
	@param color Either a colorString or color-table for the text color [optional]
]]
function Button:_new(msg, color)
	Dharma.Classes.Widget._new(self)
	Button:SetText(msg, color)
	self:EnableTouch(true, true)
end

--[[!
	Draws the button
]]
function Button:OnDraw()
	Dharma.Classes.Widget.OnDraw(self)

	local x,y = self:GetScreenPos()
	local height = self.height
	local endWidth = height/35*11
	local midWidth = self.width-endWidth*2

	btnLeft:draw(x, y, endWidth, height)
	btnMiddle:draw(x+endWidth, y, midWidth, height)
	btnRight:draw(x+endWidth+midWidth, y, endWidth, height)

	if(self.text) then
		text.color(self.color)
		text.size(self.height * 0.5)
		text.draw(x, y+self.height*0.25, self.text, "center", x+self.width)
	end
end

--[[!
	Sets the text and text color of the button
	@param text The caption of the button [optional]
	@param color Either a colorString or color-table for the text color [optional]
]]
function Button:SetText(msg, color)
	self.color = Dharma.Color(color) or self.color
	self.text = msg
	self:UpdateScreen()
end

--[[!
	Sets the text by using string.format(format, ...)
	@param format The format string
	@param ... The arguments for format
]]
function Button:SetFormattedText(msg, ...)
	self:SetText(msg:format(...))
end

--[[!
	Sets the text color
	@param color Either a colorString or color-table for the text color
]]
function Button:SetColor(color)
	self.color = Dharma.Color(color)
	self:UpdateScreen()
end