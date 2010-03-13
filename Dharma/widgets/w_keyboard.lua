--[[!

	@name		Dharma
	@author		Constantin Schomburg <xconstruct@gmail.com>
	@version	0.1

	Dharma is a framework for Creative Zen X-Fi 2 Applications.
	The core introduces methods for creating OOP classes and
	handles loading of additional files, including the GUI widgets.

	@section LICENSE

    Dharma: A Framework for Creative Zen X-Fi 2 Applications

    Copyright (C) 2310  Constantin Schomburg <xconstruct@gmail.com>

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
	@class KeyboardButton
	A button of the keyboard
]]

local KeyBoardButton = Dharma.NewClass("KeyBoardButton", "Button")

function KeyBoardButton:_new(keyboard, text, width, x, y)
	Dharma.Classes.Button._new(self)

	self.keyboard = keyboard
	self.height = 35
	self.text = text
	self.x, self.y = x, y
	self.width = width
end

function KeyBoardButton:OnTouchDown(x, y) self.keyboard:OnTouchDown(x,y) end
function KeyBoardButton:OnTouchUp(x, y) self.keyboard:OnTouchUp(x, y) end
function KeyBoardButton:OnTouchMove(x, y) self.keyboard:OnTouchMove(x, y) end

function KeyBoardButton:OnTouchHold() return self.keyboard.OnKeyHold and self.keyboard.OnKeyHold(self.text) end
function KeyBoardButton:OnTouchClick() return self.keyboard.OnKeyClick and self.keyboard.OnKeyClick(self.text) end

--[[!
	@class Keyboard
	Creates a keyboard to input text
]]

local KeyBoard = Dharma.NewClass("KeyBoard", "Widget")
KeyBoard.height = 110

--[[!
	Constructor
]]
function KeyBoard:_new(...)
	Dharma.Classes.Widget._new(self, ...)

	self:New("KeyBoardButton", self, "<-", 35, 11*35-23, 5)
	self:New("KeyBoardButton", self, "Enter", 80, 9*35, 40)
	self:New("KeyBoardButton", self, "Space", 80, 8*35-23, 75)
	self:New("KeyBoardButton", self, "Close", 57, 8*35-23+80, 75)

	local layout1 = self:New("Widget")
	layout1:SetHidden(true)

		for i, key in pairs{ "q", "w", "e", "r", "t", "y", "u", "i", "o", "p" } do
			layout1:New("KeyBoardButton", self, key, 35, 35*i-23, 5)
		end
		for i, key in pairs{ "a", "s", "d", "f", "g", "h", "j", "k", "l" } do
			layout1:New("KeyBoardButton", self, key, 35, 35*i-35, 40)
		end
		for i, key in pairs{ "z", "x", "c", "v", "b", "n", "m" } do
			layout1:New("KeyBoardButton", self, key, 35, 35*i-23, 75)
		end

	local layout2 = self:New("Widget")
	layout2:SetHidden(true)

		for i, key in pairs{ "Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P" } do
			layout2:New("KeyBoardButton", self, key, 35, 35*i-23, 5)
		end
		for i, key in pairs{ "A", "S", "D", "F", "G", "H", "J", "K", "L" } do
			layout2:New("KeyBoardButton", self, key, 35, 35*i-35, 40)
		end
		for i, key in pairs{ "Z", "X", "C", "V", "B", "N", "M" } do
			layout2:New("KeyBoardButton", self, key, 35, 35*i-23, 75)
		end

	local layout3 = self:New("Widget")
	layout3:SetHidden(true)

		for i, key in pairs{ "1", "2", "3", "4", "5", "6", "7", "8", "9", "0" } do
			layout3:New("KeyBoardButton", self, key, 35, 35*i-23, 5)
		end
		for i, key in pairs{ "!", "@", "#", "$", "%", "^", "&", "*", "?" } do
			layout3:New("KeyBoardButton", self, key, 35, 35*i-35, 40)
		end
		for i, key in pairs{ "?", ",", ".", "-", ";", ":", "/"} do
			layout3:New("KeyBoardButton", self, key, 35, 35*i-23, 75)
		end

	local layout4 = self:New("Widget")
	layout4:SetHidden(true)

		for i, key in pairs{ "<", ">", "|", "(", ")", "[", "]", "{", "}", "Ö" } do
			layout4:New("KeyBoardButton", self, key, 35, 35*i-23, 5)
		end
		for i, key in pairs{ "+", "Ö", "_", "=", "\\", "~", "'", "\"" } do
			layout4:New("KeyBoardButton", self, key, 35, 35*i-35, 40)
		end

	self.Layouts = {layout1, layout2, layout3, layout4}
	self:SetLayout(1)
end

--[[!
	Sets the index of the layout to use
	@param i The index of the layout
]]
function KeyBoard:SetLayout(i)
	if(self.currLayout) then
		self.Layouts[self.currLayout]:SetHidden(true)
	end
	self.currLayout = i
	self.Layouts[i]:SetHidden(nil)
end

function KeyBoard:OnTouchDown(x, y)
	self.dY = y
end

function KeyBoard:OnTouchMove(x, y)
	self.changeLayout = true
end

--[[!
	Callback
	Switches the layout when the user moves the keyboard
]]
function KeyBoard:OnTouchUp(x, y)
	if(not self.changeLayout or not self.dY) then return end
	self.changeLayout = nil
	local current = self.currLayout

	if(self.dY > y) then
		self:SetLayout(current == #self.Layouts and 1 or current+1)
	else
		self:SetLayout(current == 1 and #self.Layouts or current-1)
	end
end

local dharmaKeyBoard, currWidget
--[[
	Opens up the default KeyBoard for a widget
	@param widget The object to which OnKey-events are redirected
	@param atTop Boolean: places the keyboard at the top
]]
function Dharma.KeyBoard(widget, atTop)
	if(not widget) then
		return dharmaKeyBoard and dharmaKeyBoard:Exit()
	end

	currWidget = widget
	screen.fillrect(0, 0, screen.width(), screen.height(), color.new(0, 0, 0, 128))

	if(not dharmaKeyBoard) then
		dharmaKeyBoard = Dharma.New("KeyBoard", "black")
		dharmaKeyBoard.OnKeyClick = function(key) return currWidget.OnKeyClick and currWidget:OnKeyClick(key) end
		dharmaKeyBoard.OnKeyHold = function(key) return currWidget.OnKeyHold and currWidget:OnKeyHold(key) end
		dharmaKeyBoard.OnDraw = function(self) Dharma.Classes.Widget.OnDraw(self) currWidget:OnDraw() end
	end

	if(atTop) then
		dharmaKeyBoard:SetPos(0, 0)
	else
		dharmaKeyBoard:SetPos(0, screen.height()-dharmaKeyBoard.height)
	end
	dharmaKeyBoard:Loop()
end

