import "../vm"

TrackParamView = {}

local gfx = playdate.graphics

local editPosition = 1
local selectedTrack = 1
local editParamMode = false

local options = {"base note", "steps", "volume"}

local function optionToVmParamValue(vm, option)
    local value = nil
  if option == "base note" then
    value = vm.baseNote
  elseif option == "steps" then
    value = #vm.steps
  elseif option == "volume" then
    value = vm.voice.volume
  end
  return value
end

local function editParamInc(vm, option)
    if option == "base note" then
        vm.baseNote = vm.baseNote + 1 
    elseif option == "steps" then
        table.insert(vm.steps, vmRandomStep())
    elseif option == "volume" then
        vmChangeVolume(vm, 0.05)
    end
end

local function editParamDec(vm, option)
    if option == "base note" then
        vm.baseNote = vm.baseNote - 1 
    elseif option == "steps" then
        table.remove(vm.steps) 
    elseif option == "volume" then
        vmChangeVolume(vm, -0.05)
    end
end

function TrackParamView.leftButtonDown(vms) 
    selectedTrack = selectedTrack - 1
    if selectedTrack < 1 then selectedTrack = #vms end
end
function TrackParamView.rightButtonDown(vms)
    selectedTrack = selectedTrack + 1
    if selectedTrack > #vms then selectedTrack = 1 end
end

function TrackParamView.upButtonDown(vms)
    local vm = vms[selectedTrack]
    if editParamMode then
        editParamInc(vm, options[editPosition])
    else
        editPosition = editPosition - 1
        if editPosition < 1 then editPosition = #options end
    end
end

function TrackParamView.downButtonDown(vms)
    local vm = vms[selectedTrack]
    if editParamMode then
        editParamDec(vm, options[editPosition])
    else
    editPosition = editPosition + 1
    if editPosition > #options then editPosition = 1 end
    end
end

function TrackParamView.AButtonDown(vms)
    currentView = "menu"
end

function TrackParamView.BButtonDown(vms)
    editParamMode = not editParamMode
end

-- DRAW
function TrackParamView.update(vms)
	gfx.clear(gfx.kColorWhite)
	gfx.setColor(gfx.kColorBlack)
    playdate.graphics.drawText("PARAMS", 20, 10)
	local vm = vms[selectedTrack]
	for i,option in ipairs(options) do
        local text = option .. ": " .. optionToVmParamValue(vm, option)
        if i == editPosition then 
            if editParamMode then 
                text = "_" .. text .. "_" 
		    else
                text = "*" .. text .. "*"
            end
        end

        playdate.graphics.drawText(text, 20, 20 + i * 40)
	end
end