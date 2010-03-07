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
	@class Image
	@extends Widget
	Creates a simple image widget

	@var image The image-table to draw
]]

local Image = Dharma.NewClass("Image", "Widget")

--[[
	@fn Image:_new(imagePath)
	Constructor function
	@param imagePath The filepath of the image
]]
function Image:_new(path)
	Dharma.Classes.Widget._new(self)
	if path then self.image = image.load(path) end
end

--[[
	@fn Image:OnDraw()
	Draws the image
]]
function Image:OnDraw()
	if(self.image) then
		self.image:draw(self.x, self.y, self.width, self.height)
	end
end