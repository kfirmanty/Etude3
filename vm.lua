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

local topScaleSteps = 10
local function inc(vm)
    vm.note = vm.note + 1
    if vm.note > topScaleSteps then vm.note = topScaleSteps end
end

local function dec(vm)
    vm.note = vm.note - 1
    if vm.note < 0 then vm.note = 0 end
end

local function randInt(max)
    return math.floor(math.random() * max)
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

possibleActions = {"i", "d", "a", "j", "f", "s"}
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
    return hasAct
end

function randomSteps(num)
    local steps = {}
    for i = 1,num do
        steps[i] = possibleActions[randInt(num)+1]
    end
    return steps
end

function vmInit(settings)
    return {note = 0, step = 0, baseNote = settings.baseNote, 
    steps = randomSteps(4), 
    scale = "minorPentatonic", ticksPerStep = 4, tick = 0}
end