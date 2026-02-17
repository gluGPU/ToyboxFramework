local BaseService = require("./BaseService")

local TestService = BaseService.new()
TestService.__index = TestService


function TestService.Init()
    TestService._executeInitHooks()
end


return TestService