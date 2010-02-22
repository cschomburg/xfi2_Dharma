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

--[[*****************************
	2. Box
		A widget with a static background color
********************************]]

local Box = Dharma.NewClass("Box", "Widget")

function Box:_draw()
	if self.color then
		screen.fillrect(self.x, self.y, self.width, self.height, self.color)
	end
end

function Box:_new(...)
	self._parent._new(self)
	self.color = Dharma.Color(...)
	return self
end