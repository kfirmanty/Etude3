import "CoreLibs/timer"
import "audio"
import "vm"
import "views/tracks"
import "views/trackparams"
import "views/menu"

local gfx = playdate.graphics
--local synths = {druminst(), newinst(2), newinst(2), newinst(2), newinst(2)}
local vms = {vmInit({baseNote = 36, voice = newinst(2)}), 
			 vmInit({baseNote = 36, voice = newinst(2)}), 
			 vmInit({baseNote = 36, voice = newinst(2)}), 
			 vmInit({baseNote = 36, voice = newinst(2)})}

local tickMs = 150
local keyTimer = nil

currentView = "tracks"

local function sequenceTick()
	for i=1,#vms do
		local vm = vms[i]
		vmTick(vm)
	end
end
keyTimer = playdate.timer.keyRepeatTimerWithDelay(tickMs, tickMs, sequenceTick)
--    keyTimer:remove()

-- INPUT
local viewToImpl = {tracks = TracksView, 
					menu = MenuView, 
					params = TrackParamView}

function playdate.BButtonDown()
	viewToImpl[currentView]["BButtonDown"](vms)
end

function playdate.AButtonDown()
	viewToImpl[currentView]["AButtonDown"](vms)
end

-- DPAD INPUT

function playdate.leftButtonDown() 
	viewToImpl[currentView]["leftButtonDown"](vms)
end

function playdate.rightButtonDown()
	viewToImpl[currentView]["rightButtonDown"](vms)
end

function playdate.upButtonDown()
	viewToImpl[currentView]["upButtonDown"](vms)
end

function playdate.downButtonDown() 
	viewToImpl[currentView]["downButtonDown"](vms)
end

-- DRAW
function playdate.update()
	playdate.timer.updateTimers()
	viewToImpl[currentView]["update"](vms)
end