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

local DebugInfoClass = Dharma.NewClass("DebugInfo", "Widget")
DebugInfoClass:SetBackgroundColor(color.new(0, 0, 0, 128))
DebugInfoClass:SetSize(nil, 28)
DebugInfoClass:EnableTouch(true, true)

function DebugInfoClass:_new()
	Dharma.Classes.Widget._new(self)

	self.Memory = self:New("Text", "Memory")
	self.Memory:SetPos(5, 5)

	self.FPS = self:New("Text", "FPS")
	self.FPS:SetPos(200, 5)
end

function DebugInfoClass:OnThink()
	self.Memory:SetFormattedText("Mem: %s", memoryFormat(collectgarbage("count")))
	self.FPS:SetFormattedText("FPS: %d", self:GetFPS())
end

function DebugInfoClass:OnClick(self)
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