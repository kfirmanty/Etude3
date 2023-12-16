import "utils"
import "audio"

-- i - increase note
-- d = decrease note
-- a = random note
-- f = faster
-- s = slower
-- j = jump to random step

-- l = shift left
-- r =  shift right
-- n = nop
-- c = chaos - change random operator at random position
-- p = explicit play note

-- t = trigger tracks that depend on the current one
-- m = mute or unmute track
-- two modes = play on each tick, or use explicit play
-- allow to set how many steps to execute at once

possibleActions = {"i", "d", "a", "j", "f", "s"}

local topScaleSteps = 10
local function inc(vm)
    vm.note = vm.note + 1
    if vm.note > topScaleSteps then vm.note = topScaleSteps end
end

local function dec(vm)
    vm.note = vm.note - 1
    if vm.note < 0 then vm.note = 0 end
end

local function randomNote(vm)
    vm.note = randInt(topScaleSteps)
end

local function jumpToRandomStep(vm)
    vm.step = randInt(#vm.steps)
end

local function faster(vm)
    vm.ticksPerStep = vm.ticksPerStep - 1
    if vm.ticksPerStep < 1 then vm.ticksPerStep = 1 end
end

local function slower(vm)
    vm.ticksPerStep = vm.ticksPerStep + 1
    if vm.ticksPerStep > 8 then vm.ticksPerStep = 8 end
end

local actions = {i = inc, d = dec, a = randomNote, j = jumpToRandomStep, f = faster, s = slower}
local scales = {minorPentatonic = {0, 3, 5, 7, 10}}

function vmToMidiNote(vm)
    local scale = scales[vm.scale]
    local octave = math.floor(vm.note / #scale)
    local scaleStep = vm.note % #scale
    return vm.baseNote + (octave * 12) + scale[scaleStep + 1]
end

function vmTick(vm)
    local hasAct = false
    if vm.tick % vm.ticksPerStep == 0 then
        hasAct = true
        vm.tick = 0
        local action = vm.steps[vm.step + 1]
        actions[action](vm)
        vm.step = vm.step + 1
        if vm.step >= #vm.steps then vm.step = 0 end
    end
    vm.tick = vm.tick + 1
    if hasAct then
        vm.synth:playMIDINote(vmToMidiNote(vm), 0.5, 0.1)
    end
    return hasAct
end

function vmRandomStep()
    return possibleActions[randInt(#possibleActions)+1]
end

local function randomSteps(num)
    local steps = {}
    for i = 1,num do
        steps[i] = vmRandomStep()
    end
    return steps
end

function vmChangeVoiceWave(vm, waveformName)
    
end


function vmChangeVolume(vm, volumeChange)
    vm.voice.volume = vm.voice.volume + volumeChange
    synthChangeVolume(vm.synth, vm.voice.volume)
end

function vmInit(settings)
    return {note = 0, baseNote = settings.baseNote, 
    step = 0, steps = randomSteps(4), 
    scale = "minorPentatonic", ticksPerStep = 4, tick = 0,
    voice = settings.voice,
    synth = newinst(settings.voice)}
end