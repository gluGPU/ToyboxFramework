--!strict
--[[
    Audio.luau
    2/25/26
    @gluGPU
--]]

local SoundService = game:GetService("SoundService")

local AudioStems = require("@self/AudioStems")
local BaseService = require("./BaseService")
local EngineEnums = require("../EngineEnums")
local EngineTypes = require("../EngineTypes")
local Logger = require("../Classes/Logger")

export type AudioStems = AudioStems.AudioStems
export type AudioGroup = typeof(EngineEnums.AudioGroups.Ambient)

export type Audio = {
    _output: AudioDeviceOutput,

    SoundGroups: {
        [EngineEnums.EnumItem<"AudioGroup", number>]: SoundGroup
    },

    ConvertIdsToPlayers: (ids: {[string]: string}) -> ({[string]: AudioPlayer}),

    CreateAudioStems: (name: string, destination: AudioEmitter | AudioDeviceOutput, stems: {[string]: AudioPlayer}) -> (AudioStems),
    CreateAudioStems2D: (name: string, stems: {[string]: AudioPlayer}) -> (AudioStems),

    SetAudioGroupVolume: (groupName: AudioGroup, volume: number) -> (),
}

local logger = Logger.new("Audio", true)

--[=[
    @class Audio
]=]
local Audio = BaseService.new() :: BaseService.BaseService & Audio

local output = Instance.new("AudioDeviceOutput")
output.Parent = SoundService
Audio._output = output

local groups = {}
Audio.SoundGroups = groups
for _, enum in EngineEnums.AudioGroups:GetEnumItems() do
    local soundGroup = Instance.new("SoundGroup")
    soundGroup.Volume = 1
    soundGroup.Parent = SoundService

    groups[enum] = soundGroup
end

function Audio.Init()
    logger:Print("Initializing...")

    Audio.Initialized = true
    Audio._executeInitHooks()
end


function Audio.ConvertIdsToPlayers(ids: {[string]: string}): {[string]: AudioPlayer}
    local t: {[string]: AudioPlayer} = {}

    for i, v in ids do
        local audioPlayer = Instance.new("AudioPlayer")
        audioPlayer.Name = i
        audioPlayer.Asset = v
        audioPlayer.AutoLoad = true
        t[i] = audioPlayer
    end

    return t
end


function Audio.CreateAudioStems(name: string, destination: AudioEmitter | AudioDeviceOutput, stems: {[string]: AudioPlayer}): AudioStems
    return AudioStems.new(name, destination, stems)
end


function Audio.CreateAudioStems2D(name: string, stems: {[string]: AudioPlayer}): AudioStems
    return Audio.CreateAudioStems(name, Audio._output, stems)
end


function Audio.SetAudioGroupVolume(groupName: AudioGroup, volume: number)
    
end


return Audio