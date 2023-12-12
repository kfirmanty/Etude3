import "CoreLibs/timer"
import "audio"
import "vm"

local gfx = playdate.graphics

local synths = {druminst(), newinst(2), newinst(2), newinst(2), newinst(2)}

local vm = vmInit({baseNote = 36})
local editPosition = 1

local tickMs = 500
local keyTimer = nil

-- INPUT

function playdate.BButtonDown()
    local function sequenceTick()
		--synths[1]:playMIDINote(35, 0.5, 0.1)
		--synths[2]:playMIDINote(60, 0.5, 0.1)
		vmTick(vm)
		local midiNote = vmToMidiNote(vm)
		synths[2]:playMIDINote(midiNote, 0.5, 0.1)
    end
    keyTimer = playdate.timer.keyRepeatTimerWithDelay(tickMs, tickMs, sequenceTick)
end

function playdate.BButtonUp()
    keyTimer:remove()
end

-- DPAD INPUT

function playdate.leftButtonDown() 
	editPosition = editPosition - 1
	if editPosition < 1 then editPosition = 1 end
end
function playdate.rightButtonDown() 
	editPosition = editPosition + 1
	if editPosition > #vm.steps then editPosition = #vm.steps end
end

function playdate.upButtonDown()

	local currentActionIndex = 1
	local currentAction = vm.steps[editPosition]
	for i,action in ipairs(possibleActions) do
		if(action == currentAction) then
			currentActionIndex = i
		end
	end
	currentActionIndex = currentActionIndex + 1
	if currentActionIndex > #possibleActions then currentActionIndex = 1 end
	vm.steps[editPosition] = possibleActions[currentActionIndex]
end
function playdate.downButtonDown() end

-- DRAW

function playdate.update()
	playdate.timer.updateTimers()
	gfx.clear(gfx.kColorWhite)
	gfx.setColor(gfx.kColorBlack)
	local text = ""
	for i,v in ipairs(vm.steps) do
		if i == vm.step + 1 then 
			text = text .. "*" .. v .. "*   "
		elseif i == editPosition then
			text = text .. "_" .. v .. "_   "
		else
			text = text .. v .. "   "
		end
	end
	playdate.graphics.drawText(text, 20, 100)
end