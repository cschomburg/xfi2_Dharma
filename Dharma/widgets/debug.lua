--[[!

	@name		Dharma
	@author		Constantin Schomburg <xconstruct@gmail.com>
	@version	0.1

	@section DESCRIPTION

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
	@class DebugInfo
	@extends Widget
	@implements Text
	Holds additional debugging info
]]

local Debug = {}
Dharma.Debug = Debug

local function memoryFormat(kb)
	if(kb >= 1024) then
		return ("%.2fmb"):format(kb/1024)
	elseif(kb >= 1) then
		return ("%.2fkb"):format(kb)
	else
		return ("%.0fb"):format(kb*1024)
	end
end

local DebugInfo = Dharma.NewClass("DebugInfo", "Widget")
DebugInfo:SetBackgroundColor(color.new(0, 0, 0, 128))
DebugInfo:SetSize(nil, 28)
DebugInfo:EnableTouch(true, true)

--[[!
	@fn DebugInfo:_new()
	Constructor function
]]
function DebugInfo:_new()
	Dharma.Classes.Widget._new(self)

	self.Memory = self:New("Text", "Memory")
	self.Memory:SetPos(5, 5)

	self.FPS = self:New("Text", "FPS")
	self.FPS:SetPos(200, 5)
end

--[[!
	@fn DebugInfo:OnThink()
	Updates the display
]]
function DebugInfo:OnThink()
	self.Memory:SetFormattedText("Mem: %s", memoryFormat(collectgarbage("count")))
	self.FPS:SetFormattedText("FPS: %d", self:GetFPS())
end

--[[!
	@fn DebugInfo:OnClick()
	Triggers the garbage collector
]]
function DebugInfo:OnClick()
	collectgarbage("collect")
end

function Debug:Toggle()
	if(self.DebugInfo and self.DebugInfo:IsHidden()) then
		self.DebugInfo:SetHidden(nil)
	elseif(self.DebugInfo) then
		self.DebugInfo:SetHidden(true)
	else
		self.DebugInfo = self:New("DebugInfo")
	end
end