local snd = playdate.sound

local waveforms = {sine = snd.kWaveSine,
square = snd.kWaveSquare,
sawtooth = snd.kWaveSawtooth,
triangle = snd.kWaveTriangle,
noise = snd.kWaveNoise,
phase = snd.kWavePOPhase,
digital = snd.kWavePODigital,
vosim = snd.kWavePOVosim}

possibleWaveforms = {"sine", "square", "sawtooth", "triange", "noise", "phase", "digital", "vosim"}

function synthChangeWaveform(synth, waveName)
	synth:setWaveform(waveforms[waveName])
end

function synthChangeVolume(synth, volume)
	synth:setVolume(volume)
end

function newsynth(settings)
	local s = snd.synth.new(waveforms[settings.waveform])
	s:setVolume(settings.volume)
	s:setAttack(0)
	s:setDecay(0.15)
	s:setSustain(0.0)
	s:setRelease(0.15)
	return s
end

function drumsynth(path, code)
	local sample = snd.sample.new(path)
	local s = snd.synth.new(sample)
	s:setVolume(0.5)
	return s
end

function newinst(settings)
	local inst = snd.instrument.new()
	for i=1,settings.polyphony do
		inst:addVoice(newsynth(settings))
	end
	inst:setVolume(settings.volume)
	return inst
end

function druminst()
	local inst = snd.instrument.new()
	inst:addVoice(drumsynth("drums/kick"), 35)
	inst:addVoice(drumsynth("drums/kick"), 36)
	inst:addVoice(drumsynth("drums/snare"), 38)
	inst:addVoice(drumsynth("drums/clap"), 39)
	inst:addVoice(drumsynth("drums/tom-low"), 41)
	inst:addVoice(drumsynth("drums/tom-low"), 43)
	inst:addVoice(drumsynth("drums/tom-mid"), 45)
	inst:addVoice(drumsynth("drums/tom-mid"), 47)
	inst:addVoice(drumsynth("drums/tom-hi"), 48)
	inst:addVoice(drumsynth("drums/tom-hi"), 50)
	inst:addVoice(drumsynth("drums/hh-closed"), 42)
	inst:addVoice(drumsynth("drums/hh-closed"), 44)
	inst:addVoice(drumsynth("drums/hh-open"), 46)
	inst:addVoice(drumsynth("drums/cymbal-crash"), 49)
	inst:addVoice(drumsynth("drums/cymbal-ride"), 51)
	inst:addVoice(drumsynth("drums/cowbell"), 56)
	inst:addVoice(drumsynth("drums/clav"), 75)
	return inst
end