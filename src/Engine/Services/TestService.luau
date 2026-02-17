local BaseService = require("./BaseService")
local Logger = require("../Classes/Logger")
local logger = Logger.new("TestingService", true)

local TestService = BaseService.new()

function TestService.Init()
    logger:Print("Initializing...")
    
    TestService.Initialized = true
    TestService._executeInitHooks()
end


return TestService