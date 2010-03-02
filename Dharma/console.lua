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

local Console = Dharma.New("Widget", "black")
Dharma.Console = Console

local Clock = Console:New("Text", "Clock")
Clock:SetPos(5, 5)

local Time = Console:New("Text", "Time")
Time:SetPos(130, 5)

local Memory = Console:New("Text", "Memory")
Memory:SetPos(200, 5)

local msgLines = {}
for i=1, 14 do
	local line = Console:New("Text", nil, 14)
	line:SetPos(5, 25 + i*14)
	msgLines[i] = line
end

local function clockFormat(sec)
	if(sec >= 3600) then
		return ("%.2fh"):format(sec/3600)
	elseif(sec >= 60) then
		return ("%.2fm"):format(sec/60)
	else
		return ("%.2fs"):format(sec)
	end
end

local function memoryFormat(kb)
	if(kb >= 1024) then
		return ("%.2fmb"):format(kb/1024)
	elseif(kb >= 1) then
		return ("%.2fkb"):format(kb)
	else
		return ("%.0fb"):format(kb*1024)
	end
end

function Console:OnThink()
	Clock:SetText("Clock: "..clockFormat(os.clock()))
	Time:SetText("Time: "..clockFormat(os.time())
	Memory:SetText("Mem: "..memoryFormat(collectgarbage("count")))
end

function Console:OnPowerClick()
	Console:Exit()
end

function Console:OnHomeClick()
	collectgarbage("collect")
end

function Console:Error(msg)
	local i, pos = 1, 1
	while(#msg > 0) do
		local text = msg:sub(1, 55)
		msg = msg:sub(56)
		if(msgLines[i]) then
			msgLines[i]:SetText(text)
		end
		i = i+1
	end

	self:Loop(10)
end