import "../vm"

TracksView = {}

local gfx = playdate.graphics

local editPosition = 1
local selectedTrack = 1

function TracksView.leftButtonDown(vms) 
	editPosition = editPosition - 1
	if editPosition < 1 then editPosition = 1 end
end
function TracksView.rightButtonDown(vms)
	local vm = vms[selectedTrack]
	editPosition = editPosition + 1
	if editPosition > #vm.steps then editPosition = #vm.steps end
end

local function currentActionIndex(vm)
	local currentActionIndex = 1
		local currentAction = vm.steps[editPosition]
		for i,action in ipairs(possibleActions) do
			if(action == currentAction) then
				currentActionIndex = i
			end
		end
	return currentActionIndex
end

function TracksView.upButtonDown(vms)
	if playdate.buttonIsPressed(playdate.kButtonB) then
		local vm = vms[selectedTrack]
		local currentActionIndex = currentActionIndex(vm)
		currentActionIndex = currentActionIndex + 1
		if currentActionIndex > #possibleActions then currentActionIndex = 1 end
		vm.steps[editPosition] = possibleActions[currentActionIndex]
	else
		selectedTrack = selectedTrack - 1
		if selectedTrack < 1 then selectedTrack = #vms end
	end
end

function TracksView.downButtonDown(vms)
	if playdate.buttonIsPressed(playdate.kButtonB) then
		local vm = vms[selectedTrack]
		local currentActionIndex = currentActionIndex(vm)
		currentActionIndex = currentActionIndex - 1
		if currentActionIndex < 1 then currentActionIndex = #possibleActions end
		vm.steps[editPosition] = possibleActions[currentActionIndex]
	else
		selectedTrack = selectedTrack + 1
		if selectedTrack > #vms then selectedTrack = 1 end
	end
end

function TracksView.AButtonDown(vms)
    currentView = "menu"
end

function TracksView.BButtonDown(vms) 
end

-- DRAW
function TracksView.update(vms)
	gfx.clear(gfx.kColorWhite)
	gfx.setColor(gfx.kColorBlack)
    gfx.drawText("TRACKS", 20, 10)
	for vmI=1,#vms do
		local vm = vms[vmI]
		local text = ""
		for i,v in ipairs(vm.steps) do
            if i == editPosition and vmI == selectedTrack then
                text = text .. "*" .. v .. "*   "
            elseif i == vm.step + 1 then 
                text = text .. "_" .. v .. "_   "
			else
				text = text .. v .. "   "
			end
		end
		gfx.drawText(text, 20, 20 + vmI * 30)

		if vm.playedNote then
			gfx.drawText(vmToDisplayNote(vm) .. "   ", 0 + vmI * 20, 220)
		end
	end
end