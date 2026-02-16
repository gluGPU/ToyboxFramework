local BaseService = require("./_BaseService")

local TestService = {}
TestService.__index = TestService
setmetatable(TestService, BaseService)

return TestService