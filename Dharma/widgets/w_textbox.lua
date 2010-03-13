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
	@class TextBox
	@extends Text
	Creates a simple editable text widget
]]

local TextBox = Dharma.NewClass("TextBox", "Text")
TextBox:EnableTouch(true, true)
TextBox.bgColor = color.new(255, 255, 255)
TextBox.color = color.new(0, 0, 0)
TextBox.borderColor = TextBox.color
TextBox.margin = 5
TextBox.width = 100

--[[!
	Callback
	Opens the keyboard
]]
function TextBox:OnTouchClick()
	local x,y = self:GetScreenPos()
	Dharma.KeyBoard(self, y+self.height > screen.width()/2)
end

--[[!
	Callback
	Modifies the text depending on the key pressed
]]
function TextBox:OnKeyClick(key)
	if(key == "Enter" or key == "Close") then
		return Dharma.KeyBoard()
	elseif(key == "Space") then
		key = " "
	elseif(key == "<-") then
		return self:SetText(self.text:sub(0, -2))
	end

	if(not self.maxChars or #self.text < self.maxChars) then
		self:SetText(self.text..key)
	end
end
TextBox.OnKeyHold = TextBox.OnKeyClick