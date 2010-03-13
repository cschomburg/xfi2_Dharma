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
	@var bgTextures indexed table holding the three background textures
]]

local Button = Dharma.NewClass("Button", "Text")
Button:EnableTouch(true, true)
Button.width = 100
Button.height = 35

Button.bgTextures = {
	image.load("Dharma/images/button-left.png"),
	image.load("Dharma/images/button-middle.png"),
	image.load("Dharma/images/button-right.png"),
}

--[[!
	Constructor
	@param text The caption of the button [optional]
	@param color Either a colorString or color-table for the text color [optional]
]]
function Button:_new(msg, color)
	Dharma.Classes.Text._new(self, msg, nil, color)
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

	if(self.bgTextures) then
		self.bgTextures[1]:draw(x, y, endWidth, height)
		self.bgTextures[2]:draw(x+endWidth, y, midWidth, height)
		self.bgTextures[3]:draw(x+endWidth+midWidth, y, endWidth, height)
	end

	if(self.text) then
		text.color(self.color)
		text.size(self.height * 0.5)
		text.draw(x, y+self.height*0.25, self.text, "center", x+self.width)
	end
end

--[[!
	Sets the background textures of the button
	@param arg1 An indexed table holding the new images (left, middle, right)
	@param arg1 The generic image path for textures, Dharma will append "-left.png" and so on
]]
function Button:SetButtonTextures(arg1)
	if(type(arg1) == "table") then
		self.bgTextures = arg1
	elseif(arg1) then
		self.bgTextures = {
			image.load(path.."-left.png"),
			image.load(path.."-middle.png"),
			image.load(path.."-right.png"),
		}
	end
	self:UpdateScreen()
end