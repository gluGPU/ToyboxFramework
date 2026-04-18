--!strict
--[[
    AudioStems.luau
    2/25/26
    @gluGPU
--]]

local ContentProvider = game:GetService("ContentProvider")

local Logger = require("../../Classes/Logger")
local Signal = require("../../Libraries/Signal/SignalPlus")

local AudioStems = {}
AudioStems.__index = AudioStems

type AudioStemsData = {
    _logger: Logger.Logger,

    Name: string,
    Stems: {[string]: AudioPlayer},
    _volumes: {[string]: number},
    _wires: {Wire},
    _emitter: AudioEmitter | AudioDeviceOutput,


    _currentPlayThread: thread?,
    _startTime: number,
    _startPosition: number,
    _isLoading: boolean,

    Volume: number,
    IsPlaying: boolean,
    IsReady: boolean,
    Looping: number,
    
    LoopRegion: NumberRange,
    PlaybackRegion: NumberRange,

    IsReadyChanged: Signal.Signal<boolean>,


    Destroy: (self: AudioStems) -> (),
    
    SetVolume: (self: AudioStems, volume: number) -> (),
    SetStemVolume: (self: AudioStems, name: string, volume: number) -> (),
    SetTimePosition: (self: AudioStems, newTime: number) -> (),

    GetTimePosition: (self: AudioStems) -> (number),

    PreloadStems: (self: AudioStems) -> (),
    
    Play: (self: AudioStems) -> (),
    Stop: (self: AudioStems) -> (),
    Pause: (self: AudioStems) -> (),
}

export type AudioStems = typeof(setmetatable({} :: AudioStemsData, AudioStems))

function AudioStems.new(name: string, destination: AudioEmitter | AudioDeviceOutput, stems: {[string]: AudioPlayer}): AudioStems
    local self: AudioStems = setmetatable({} :: AudioStemsData, AudioStems)
    
    local logger = Logger.new("AudioStems_"..name, true)
    self._logger = logger

    local wires = {}
    local volumes = {}

    for i, player in stems do
        local wire = Instance.new("Wire")
        wire.SourceInstance = player
        wire.TargetInstance = destination
        wire.Name = "Stem_".. name.. player.Name
        wire.Parent = player

        player:Stop()
        player.AutoPlay = false
        player.TimePosition = 0
        player.Parent = destination

        volumes[i] = player.Volume
        table.insert(wires, wire)
    end

    self._volumes = volumes
    self._wires = wires
    self._emitter = destination

    self.Name = name
    self.Stems = stems

    self._currentPlayThread = nil
    self._startTime = os.clock()
    self._startPosition = 0
    self._isLoading = false

    self.Volume = 1
    self.IsPlaying = false
    self.IsReady = true

    self.IsReadyChanged = Signal() :: Signal.Signal<boolean>

    for _, player in stems do
        if not player.IsReady then
            self.IsReady = false
            break
        end
    end

    return self
end


function AudioStems.Destroy(self: AudioStems)
    if self.IsPlaying then
        self:Pause()
    end

    for _, wire in self._wires do
        wire:Destroy()
    end

    for _, player in self.Stems do
        player:Destroy()
    end

    setmetatable(self, nil)
    table.clear(self)
end


function AudioStems.SetVolume(self: AudioStems, volume: number)
    self.Volume = volume

    for i, player in self.Stems do
        player.Volume = volume * self._volumes[i]
    end
end


function AudioStems.SetStemVolume(self: AudioStems, name: string, volume: number)
    local player = self.Stems[name]
    if player then
        self._volumes[name] = volume
        player.Volume = volume * self.Volume
    end
end


function AudioStems.SetTimePosition(self: AudioStems, time: number)
    self._startPosition = time

    for _, player in self.Stems do
        player.TimePosition = time
    end
end


function AudioStems.GetTimePosition(self: AudioStems): number
    return self._startPosition + (os.clock() - self._startTime)
end


function AudioStems.PreloadStems(self: AudioStems)
    local logger = self._logger

    logger:Print("Started preloading audio.")
    self._isLoading = true

    local array = {}
    for _, audioPlayer in self.Stems do
        table.insert(array, audioPlayer)
    end

    ContentProvider:PreloadAsync(array, function(id, status)
        id = id :: string
        status = status :: Enum.AssetFetchStatus

        if status == Enum.AssetFetchStatus.Success then
            logger:Print(string.format(
                "Audio loaded. Id: %s, Status: %*", id, status
            ))
        else
            logger:Warn(string.format(
                "Audio loading failed. Id: %s, Status: %*", id, status
            ))
        end
    end)

    self._isLoading = false
    self.IsReady = true
    logger:Print("Completed preloading audio.")

    table.clear(array)
    array = nil

    self.IsReadyChanged:Fire(true)
end


function AudioStems.Play(self: AudioStems)
    local t = self._currentPlayThread
    if t then
        task.cancel(t)
        t = nil
    end

    self.IsPlaying = true
    self._currentPlayThread = task.spawn(function()
        if not self.IsReady then
            if not self._isLoading then
                self:PreloadStems()
            end
        end

        self._logger:Print("Playing")
        self._startTime = os.clock()
        -- local pos = self:GetTimePosition()

        -- No matter what I do, AudioPlayers won't line up unless
        -- TimePosition is at 0. So if you're using AudioStems,
        -- you're better off using it in situations where you
        -- won't have to puase the music

        for _, player: AudioPlayer in self.Stems do
            task.defer(function()
                player.TimePosition = self:GetTimePosition()
                player:Play()
            end)
            
        end
    end)
end


function AudioStems.Stop(self: AudioStems)
    if self.IsPlaying then
        self.IsPlaying = false
        
        local t = self._currentPlayThread
        if t then
            task.cancel(t)
            self._currentPlayThread = nil
            t = nil
        end

        for _, player: AudioPlayer in self.Stems do
            player:Stop()
        end

        self:SetTimePosition(0)
    end
end


function AudioStems.Pause(self: AudioStems)
    if self.IsPlaying then
        self.IsPlaying = false

        local t = self._currentPlayThread
        if t then
            task.cancel(t)
            self._currentPlayThread = nil
            t = nil
        end

        for _, player: AudioPlayer in self.Stems do
            player:Stop()
        end

        task.defer(function()
            self:SetTimePosition(self:GetTimePosition())
        end)
    end
end


return AudioStems