import "utils"
import "audio"

-- i - increase note
-- d = decrease note
-- a = random note
-- f = faster
-- s = slower
-- j = jump to random step
-- t = trigger note
-- n = nop
-- c = chaos - change random operator at random position

-- l = shift left
-- r =  shift right

-- m = mute or unmute track
-- two modes = play on each tick, or use explicit play
-- allow to set how many steps to execute at once

possibleActions = {"t", "i", "d", "a", "j", "f", "s", "c", "n"}

function vmRandomStep()
    return possibleActions[randInt(#possibleActions) + 1]
end

local function randomSteps(num)
    local steps = {}
    for i = 1, num do
        steps[i] = vmRandomStep()
    end
    steps[1] = "t"
    return steps
end

local topScaleSteps = 10
local function inc(vm)
    vm.note = vm.note + 1
    if vm.note > topScaleSteps then
        vm.note = topScaleSteps
    end
end

local function dec(vm)
    vm.note = vm.note - 1
    if vm.note < 0 then
        vm.note = 0
    end
end

local function randomNote(vm)
    vm.note = randInt(topScaleSteps)
end

local function jumpToRandomStep(vm)
    vm.step = randInt(#vm.steps)
end

local function faster(vm)
    vm.ticksPerStep = vm.ticksPerStep - 1
    if vm.ticksPerStep < 1 then
        vm.ticksPerStep = 1
    end
end

local function slower(vm)
    vm.ticksPerStep = vm.ticksPerStep + 1
    if vm.ticksPerStep > 8 then
        vm.ticksPerStep = 8
    end
end

local function trigger(vm)
    if vm.explicitTrigger then
        vm.synth.instrument:playMIDINote(vmToMidiNote(vm), 0.5, 0.1)
        vm.playedNote = true
    end
end

local function nop(vm)
end

local function chaos(vm)
    local steps = vm.steps
    steps[randInt(#steps) + 1] = vmRandomStep()
end

local actions = {
    t = trigger,
    i = inc,
    d = dec,
    a = randomNote,
    j = jumpToRandomStep,
    f = faster,
    s = slower,
    n = nop,
    c = chaos
}
local scales = {minorPentatonic = {0, 3, 5, 7, 10}}

local baseNotes = {"C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"}

function vmBaseNote(vm)
    return baseNotes[vm.baseNote + 1]
end

function vmChangeBaseNote(vm, dir)
    local newBaseNote = vm.baseNote + dir
    if newBaseNote < 0 then
        newBaseNote = #baseNotes - 1
    elseif newBaseNote >= #baseNotes then
        newBaseNote = 0
    end
    vm.baseNote = newBaseNote
end

function vmToMidiNote(vm)
    local scale = scales[vm.scale]
    local octave = math.floor(vm.note / #scale)
    local scaleStep = vm.note % #scale
    return vm.baseNote + (vm.octave * 12) + (octave * 12) + scale[scaleStep + 1]
end

function vmToDisplayNote(vm)
    local midiNote = vmToMidiNote(vm)
    local note = midiNote % 12
    return baseNotes[note + 1]
end

function vmTick(vm)
    vm.playedNote = false
    local hasAct = false
    if vm.tick % vm.ticksPerStep == 0 then
        hasAct = true
        vm.tick = 0
        local action = vm.steps[vm.step + 1]
        actions[action](vm)
        vm.step = vm.step + 1
        if vm.step >= #vm.steps then
            vm.step = 0
        end
    end
    vm.tick = vm.tick + 1
    if hasAct and (not vm.explicitTrigger) then
        vm.synth.instrument:playMIDINote(vmToMidiNote(vm), 0.5, 0.1)
        vm.playedNote = true
    end
    return hasAct
end

function vmChangeVoiceWave(vm, dir)
    local currentWaveformIndex = 1
    local currentWaveform = vm.voice.waveform
    for i, waveform in ipairs(possibleWaveforms) do
        if waveform == currentWaveform then
            currentWaveformIndex = i
        end
    end
    currentWaveformIndex = currentWaveformIndex + dir
    if currentWaveformIndex < 1 then
        currentWaveformIndex = #possibleWaveforms
    elseif currentWaveformIndex > #possibleWaveforms then
        currentWaveformIndex = 1
    end
    local waveformName = possibleWaveforms[currentWaveformIndex]
    synthChangeWaveform(vm.synth, waveformName)
    vm.voice.waveform = waveformName
end

function vmChangeVolume(vm, volumeChange)
    vm.voice.volume = vm.voice.volume + volumeChange
    synthChangeVolume(vm.synth, vm.voice.volume)
end

function vmInit(settings)
    return {
        note = 0,
        baseNote = settings.baseNote,
        octave = settings.octave,
        step = 0,
        steps = randomSteps(4),
        scale = "minorPentatonic",
        ticksPerStep = 4,
        tick = 0,
        voice = settings.voice,
        synth = newinst(settings.voice),
        explicitTrigger = true,
        playedNote = false
    }
end
