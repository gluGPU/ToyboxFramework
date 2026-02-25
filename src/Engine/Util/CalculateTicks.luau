return function(delta: number, tickRate: number, speed: number): number
    return math.floor(delta / tickRate * speed)
end
