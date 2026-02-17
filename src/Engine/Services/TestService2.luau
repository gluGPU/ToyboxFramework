local BaseService = require("./BaseService")
local Logger = require("../Classes/Logger")
local logger = Logger.new("TestingService Dos", true)

local TestService2 = BaseService.new()
TestService2.__index = TestService2


function TestService2.Init()
    logger:Print("Initializing...")
    TestService2._executeInitHooks()
end


return TestService2