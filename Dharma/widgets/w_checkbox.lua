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
	@class CheckBox
	@extends Button
	Creates a clickable check box

	@var checked The value of the checkbox
]]

local CheckBox = Dharma.NewClass("CheckBox", "Text")
CheckBox:EnableTouch(true, true)
CheckBox.borderColor = color.new(0, 0, 0)
CheckBox.bgColor = color.new(255, 255, 255)
CheckBox.height = 20
CheckBox.width = 100

--[[!
	Constructor
	@param text The caption of the button [optional]
	@param color Either a colorString or color-table for the text color [optional]
	@param size The size of the box and text [optional]
	@param checked The initial state of the box [optional]
]]
function CheckBox:_new(msg, color, size, checked)
	Dharma.Classes.Text._new(self, msg, size, color)
	self:SetChecked(checked)
	self:EnableTouch(true, true)
end

--[[!
	Callback
	Draws the checkbox
]]
function CheckBox:OnDraw()
	local x,y = self:GetScreenPos()

	if(self.borderColor) then
		screen.drawrect(x-1, y-1, x+self.height, y+self.height, self.borderColor)
	end
	if(self.bgColor) then
		screen.fillrect(x, y, self.height, self.height, self.bgColor)
	end
	if(self.checked) then
		screen.drawline(x+3, y+3, x+self.height-3, y+self.height-3, self.borderColor)
		screen.drawline(x+self.height-3, y+3, x+3, y+self.height-3, self.borderColor)
	end
	if(self.text) then
		text.color(self.color)
		text.size(self.height * 0.8)
		text.draw(x+self.height+5, y+self.height*0.1, self.text)
	end
end

--[[!
	Sets the checked state of the CheckBox
	@param checked Boolean whether the checkbox is checked [optional]
]]
function CheckBox:SetChecked(checked)
	self.checked = checked
	self:UpdateScreen()
end

--[[!
	Callback
	Toggles the checked state
]]
function CheckBox:OnTouchClick()
	self:SetChecked(not self.checked)
end