local BaseService = {}
BaseService.Initialized = false
BaseService.__index = BaseService
BaseService.__newindex = function()
    print("no")
end


export type BaseService<ChildService> = {
    Hooks: {(ChildService: ChildService) -> ()},
}


function BaseService._executeInitHooks(self)
    
end

function BaseService.OnInitialized()
    
end

return BaseService