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

local Profiler = {}
Dharma.Profiler = Profiler

local points, start = {}

function Profiler.Start()
	start = os.clock()
end

function Profiler.Stop(name, highest)
	local diff = os.clock() - start
	points[name] = highest and math.max(points[name] or 0, diff) or diff
	start = os.clock()
end

local textColor = color.new(255, 255, 255)
local bgColor = color.new(0, 0, 0, 170)

function Profiler.Output(x, y)
	local i=0
	text.color(textColor)
	text.size(16)
	for name, value in pairs(points) do
		screen.fillrect(x, y+i*20, 100, 20, bgColor)
		text.draw(x+2, y+i*20+2, ("%s: %.3f"):format(name, value))
		i = i+1
	end
end