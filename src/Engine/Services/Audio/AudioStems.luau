--!strict
--[[
    AudioStems.luau
    2/25/26
    @gluGPU
--]]

local Logger = require("../../Classes/Logger")

local AudioStems = {}
AudioStems.__index = AudioStems

type AudioStemsData = {
    _logger: Logger.Logger,
    _wire: Wire,
    _emitter: AudioEmitter | AudioDeviceOutput,

    Name: string,
    Stems: {[string]: AudioPlayer},

    Volume: number,
    IsPlaying: boolean,
    TimePosition: number,
    Looping: number,
    
    LoopRegion: NumberRange,
    PlaybackRegion: NumberRange,

    Destroy: (self: AudioStems) -> (),
    
    SetVolume: (self: AudioStems, volume: number) -> (),
    SetStemVolume: (self: AudioStems, name: string, volume: number) -> (),
    SetTimePosition: (self: AudioStems, newTime: number) -> (),
    
    Play: (self: AudioStems) -> (),
    Stop: (self: AudioStems) -> (),
    Pause: (self: AudioStems) -> (),
}

export type AudioStems = typeof(setmetatable({} :: AudioStemsData, AudioStems))

function AudioStems.new(name: string, destination: AudioEmitter | AudioDeviceOutput, stems: {[string]: AudioPlayer}): AudioStems
    local self: AudioStems = setmetatable({} :: AudioStemsData, AudioStems)
    
    local logger = Logger.new("AudioStems_"..name)
    self._logger = logger
    
    local wire = Instance.new("Wire")
    wire.Name = "AudioStems_"..name
    wire.Parent = destination

    self._wire = wire
    self._emitter = destination

    self.Name = name
    self.Stems = stems

    self.Volume = 0
    self.IsPlaying = false
    self.TimePosition = 0

    return self
end


function AudioStems.Destroy(self: AudioStems)
    self._wire:Destroy()

    setmetatable(self, nil)
    table.clear(self)
end


function AudioStems.SetVolume(self: AudioStems, volume: number)
    
end


function AudioStems.SetStemVolume(self: AudioStems, name: string, volume: number)
    
end


function AudioStems.SetTimePosition(self: AudioStems, time: number)
    
end


function AudioStems.Play()
    
end


function AudioStems.Stop()
    
end


function AudioStems.Pause()
    
end


return AudioStems