import "CoreLibs/timer"
import "vm"
import "views/tracks"
import "views/trackparams"
import "views/menu"

local gfx = playdate.graphics
--local synths = {druminst(), newinst(2), newinst(2), newinst(2), newinst(2)}
local vms = {vmInit({baseNote = 24, voice = {waveform = "sawtooth", volume = 0.4, polyphony = 2}}), 
			 vmInit({baseNote = 36, voice = {waveform = "sawtooth", volume = 0.4, polyphony = 2}}), 
			 vmInit({baseNote = 36, voice = {waveform = "triangle", volume = 0.5, polyphony = 2}}), 
			 vmInit({baseNote = 48, voice = {waveform = "triangle", volume = 0.5, polyphony = 2}})}

currentView = "tracks"

local function sequenceTick()
	for i=1,#vms do
		local vm = vms[i]
		vmTick(vm)
	end
end

playbackFn = sequenceTick
startPlayback(playbackFn)

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