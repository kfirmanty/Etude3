MenuView = {}

local gfx = playdate.graphics

local menuPosition = 1
local options = {"playback", "tracks", "params"}

local tickMs = 150
local keyTimer = nil
local playback = true

function startPlayback(fn)
	playback = true
	keyTimer = playdate.timer.keyRepeatTimerWithDelay(tickMs, tickMs, fn)
end

playbackFn = nil

function stopPlayback()
	playback = false
	keyTimer:remove()
end

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
    if(options[menuPosition] == "playback") then
        if playback then
            playback = false
            stopPlayback()
        else
            startPlayback(playbackFn)
        end
    else 
        currentView = options[menuPosition]
    end
end

function MenuView.BButtonDown(vms) 
end

-- DRAW
function MenuView.update(vms)
	gfx.clear(gfx.kColorWhite)
	gfx.setColor(gfx.kColorBlack)
    gfx.drawText("MENU", 20, 10)
	for i,option in ipairs(options) do
        local text = option
        if option == "playback" then
            text = option .. ": " .. (playback and "on" or "off")
        end
		if i == menuPosition then 
		    text = "*" .. text .. "*"
        end
        gfx.drawText(text, 20, 20 + i * 30)
	end
end