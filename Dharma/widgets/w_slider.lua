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
	@class Slider
	@extends Widget
	Creates a status bar or touchable slider

	@var color The color-table of the filled part [default: red]
	@var texture The image texture of the filled part [default: Dharma/images/gradient.png]
	@var min The minimum value [default: 0]
	@var max The maximum value [default: 1]
	@var value The current value [default: 1]

	@callback OnValueChanged(value) The value has changed
]]

local Slider = Dharma.NewClass("Slider", "Widget")
Slider.color = color.new(255, 0, 0)
Slider.texture = image.load("Dharma/images/gradient.png")
Slider.min, Slider.max = 0, 1
Slider.value = 1
Slider.width, Slider.height = 200, 20

--[[!
	@fn Slider:OnDraw()
	Draws the slider
]]
function Slider:OnDraw()
	Dharma.Classes.Widget.OnDraw(self)

	local x,y = self:GetScreenPos()
	local percent = (self.value-self.min)/(self.max-self.min)

	if(self.color) then
		screen.fillrect(x, y, percent*self.width, self.height, self.color)
	end
	if(self.texture) then
		self.texture:draw(x, y, percent*self.width, self.height)
	end
end

--[[!
	@fn Slider:SetColor(color)
	Sets the color of the filled part
	@param color Either a colorString or color-table
]]
function Slider:SetColor(color)
	self.color = Dharma.Color(color)
	self:UpdateScreen()
end

--[[!
	@fn Slider:SetValue(value)
	Sets the current value of the slider
	@param value Number between min and max values
]]
function Slider:SetValue(value)
	self.value = value
	self:UpdateScreen()

	if(self.OnValueChanged) then
		self:OnValueChanged(value)
	end
end

--[[!
	@fn Slider:SetMinMaxValues(min, max)
	Sets the bounds for the value
	@param min The minimum value
	@param max The maximmum value
]]
function Slider:SetMinMaxValues(min, max)
	self.min, self.max = min, max
	self:UpdateScreen()
end

--[[!
	@fn Slider:SetTexture(image)
	@overload Slider:SetTexture(imagePath)
	Sets the texture for the filled part
	@param image The image-table to use
	@param imagePath String holding the image path
]]
function Slider:SetTexture(texture)
	self.texture = type(texture) == "string" and image.load(texture) or texture
	self:UpdateScreen()
end

--[[!
	@attention Enable touch events for this widget to let the user move the slider!
]]
function Slider:OnTouchMove(mX, mY)
	local x,y = self:GetScreenPos()
	local percent = (mX-x)/self.width
	percent = (percent < 0 and 0) or (percent > 1 and 1) or percent
	self:SetValue(self.min+percent*(self.max-self.min))
end