MenuView = {}

local gfx = playdate.graphics

local menuPosition = 1
local options = {"tracks", "params"}

function MenuView.leftButtonDown(vms) 

end
function MenuView.rightButtonDown(vms)

end

function MenuView.upButtonDown(vms)
    menuPosition = menuPosition - 1
    if menuPosition < 1 then menuPosition = #options end
end

function MenuView.downButtonDown(vms) 
    menuPosition = menuPosition + 1
    if menuPosition > #options then menuPosition = 1 end
end

function MenuView.AButtonDown(vms) 
    currentView = options[menuPosition]
end

function MenuView.BButtonDown(vms) 
end

-- DRAW
function MenuView.update(vms)
	gfx.clear(gfx.kColorWhite)
	gfx.setColor(gfx.kColorBlack)
    playdate.graphics.drawText("MENU", 20, 10)
	for i,option in ipairs(options) do
        local text = option
		if i == menuPosition then 
		    text = "*" .. text .. "*"
        end
        playdate.graphics.drawText(text, 20, 20 + i * 40)
	end
end