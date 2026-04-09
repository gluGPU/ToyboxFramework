--[[
    Tester_Audio.luau
    2/26/26
    @gluGPU
--]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Engine = require(ReplicatedStorage.Engine.Engine)

local services = Engine.Services
local Audio = services.Audio
local Debug = services.Debug
local Iris = Debug.Iris

local audioAssets = require("../Assets/audio")
local music1 = audioAssets.AirFlowStems

Engine.OnInitialized(function()
    local moving = workspace:WaitForChild("MovingAudio"):WaitForChild("Tick_Interp"):WaitForChild("AudioEmitter")
    local stemPlayers = {}

    local players = Audio.ConvertIdsToPlayers(music1)
    local airFlowStems = Audio.CreateAudioStems2D("Air Flow", players)
    -- airFlowStems:Play()

    local other = Audio.ConvertIdsToPlayers(music1)
    local airFlowStems3D = Audio.CreateAudioStems("Air Flow 3D", moving, other)

    table.insert(stemPlayers, airFlowStems)
    table.insert(stemPlayers, airFlowStems3D)

    Iris:Connect(function()
        Iris.Window({"Toybox - Audio View"})

        for _, stemPlayer in stemPlayers do
            Iris.Tree({stemPlayer.Name})
                local volume = Iris.SliderNum({
                    "Volume", 0.01, 0, 1
                }, {number = Iris.State(stemPlayer.Volume)})

                if volume.numberChanged() then
                    stemPlayer:SetVolume(volume.state.number:get())
                end

                local isPlaying = Iris.Checkbox({"Is Playing"}, {isChecked = Iris.State(stemPlayer.IsPlaying)})

                if isPlaying.checked() then
                    stemPlayer:Play()
                end

                if isPlaying.unchecked() then
                    stemPlayer:Stop()
                end

                local pause = Iris.Button({"Pause (causes desync)"})
                
                if pause.clicked() then
                    stemPlayer:Pause()
                    isPlaying.state.isChecked:set(stemPlayer.IsPlaying)
                end

                Iris.Tree({"Stems"})
                    
                    for name, stem in stemPlayer.Stems do
                        local stemVolume = Iris.SliderNum(
                            {name, 0.01, 0, 1},
                            {number = Iris.State(stem.Volume)}
                        )

                        if stemVolume.numberChanged() then
                            stemPlayer:SetStemVolume(name, stemVolume.state.number:get())
                        end
                    end
                
                Iris.End()

            Iris.End()
        end

        Iris.End()
    end)
end)
