require "Dharma/core"

local new = Dharma.New

local Background = new("Box", color.new(50, 50, 50))
Background:EnableTouch(true)

local Box = new("Image", "icon.png")
Box:SetPos(100, 100)
Box:SetSize(50)

local Text = new("Text")
Text:SetPos(5, 5)

function Background:OnTouchMove(x, y)
	Text:SetFormattedText("%d, %d", x, y)
	Box:SetPos(x-Box.width/2, y-Box.height/2)
end

Dharma.Loop(10)