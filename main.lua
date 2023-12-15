import "CoreLibs/timer"
import "audio"
import "vm"
import "views/tracks"

local gfx = playdate.graphics
local synths = {druminst(), newinst(2), newinst(2), newinst(2), newinst(2)}
local vms = {vmInit({baseNote = 36}), vmInit({baseNote = 36}), vmInit({baseNote = 36}), vmInit({baseNote = 36})}

local tickMs = 150
local keyTimer = nil

local currentView = "tracks"

local function sequenceTick()
	for i=1,#vms do
		local vm = vms[i]
		local hasAct = vmTick(vm)
		if hasAct then
			local midiNote = vmToMidiNote(vm)
			synths[i+1]:playMIDINote(midiNote, 0.5, 0.1)
		end
	end
end
keyTimer = playdate.timer.keyRepeatTimerWithDelay(tickMs, tickMs, sequenceTick)
--    keyTimer:remove()

-- INPUT
function playdate.BButtonDown()

end

function playdate.BButtonUp()
end

-- DPAD INPUT

function playdate.leftButtonDown() 
	if currentView == "tracks" then
		TracksView.leftButtonDown(vms)
	end
end
function playdate.rightButtonDown()
	if currentView == "tracks" then
		TracksView.rightButtonDown(vms)
	end
end

function playdate.upButtonDown()
	if currentView == "tracks" then
		TracksView.upButtonDown(vms)
	end
end

function playdate.downButtonDown() 
	if currentView == "tracks" then
		TracksView.downButtonDown(vms)
	end
end

-- DRAW

function playdate.update()
	playdate.timer.updateTimers()
	if currentView == "tracks" then
		TracksView.update(vms)
	end
end