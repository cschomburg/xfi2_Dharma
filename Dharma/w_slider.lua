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
	Slider
		A status bar or touchable slider
********************************]]

local Slider = Dharma.NewClass("Slider", "Widget")
Slider.color = color.new(255, 0, 0)
Slider.texture = image.load("Dharma/images/gradient.png")
Slider.min, Slider.max = 0, 1
Slider.value = 1

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

function Slider:SetColor(...)
	self.color = Dharma.Color(...)
	self:UpdateScreen()
end

function Slider:SetValue(value)
	self.value = value
	self:UpdateScreen()

	if(self.OnValueChanged) then
		self:OnValueChanged(value)
	end
end

function Slider:SetMinMaxValues(min, max)
	self.min, self.max = min, max
	self:UpdateScreen()
end

function Slider:SetTexture(texture)
	self.texture = type(texture) == "string" and image.load(texture) or texture
	self:UpdateScreen()
end

function Slider:OnTouchMove(mX, mY)
	local x,y = self:GetScreenPos()
	local percent = (mX-x)/self.width
	percent = (percent < 0 and 0) or (percent > 1 and 1) or percent
	self:SetValue(percent)
end