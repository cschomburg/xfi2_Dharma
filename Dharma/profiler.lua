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
	@section Profiler
	Measures execution time at different points
]]

local Profiler = {}
Dharma.Profiler = Profiler

local points, start = {}

--[[!
	Starts the profiling
]]
function Profiler.Start()
	start = os.clock()
end

--[[!
	Records the elapsed time at point 'name'
	@param name The name of the point
	@param highest Only record the maximum value [optional]
]]
function Profiler.Stop(name, highest)
	local diff = os.clock() - start
	points[name] = highest and math.max(points[name] or 0, diff) or diff
	start = os.clock()
end

local textColor = color.new(255, 255, 255)
local bgColor = color.new(0, 0, 0, 170)

--[[!
	Draws a list of the statistics on the screen
	@param x The x-coordinate of the topleft corner
	@param y The y-coordinate of the topleft corner
]]
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