local BaseService = require("./_BaseService")

local TestService2 = BaseService.new()
TestService2.__index = TestService2


function TestService2.Init()
    TestService2._executeInitHooks()
end


return TestService2