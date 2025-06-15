local events = {} -- [eventName] = {handler1, handler2, ...}

RegisterNetEvent('event_callback:receiveFromServer')

AddEventHandler('event_callback:receiveFromServer', function(eventName, ...)
    if not events[eventName] then print("^1The callback event: " .. eventName .. " doesn't exist!^0"); return end

    local cbArgs = {}

    for _,v in ipairs(events[eventName]) do
        cbArgs[#cbArgs+1] = {v(...)}
    end

    LocalPlayer.state:set(eventName .. ":server", nil, true) --to reset state bag
    LocalPlayer.state:set(eventName  .. ":server", cbArgs, true)
end)

function RegisterNetCallbackEvent(eventName, handler)
    events[eventName] = {}
    if type(handler) == "function" or type(handler) == "table" then
        events[eventName][#events[eventName]+1] = handler
    end
end

exports("RegisterNetCallbackEvent", RegisterNetCallbackEvent)

function AddCallbackEventHandler(eventName, handler)
    if not events[eventName] then print("^1The callback event: " .. eventName .. " doesn't exist!^0"); return end
    if type(handler) ~= "function" and type(handler) ~= "table" then print("^1The handler of the callback event: " .. eventName .. " is not a function!^0"); return end
    
    events[eventName][#events[eventName]+1] = handler
end

exports("AddCallbackEventHandler", AddCallbackEventHandler)

function TriggerCallbackEvent(eventName, ...)
    if not events[eventName] then print("^1The callback event: " .. eventName .. " doesn't exist!^0"); return end

    local args = {...}
    local cb = args[#args]

    if type(cb) == "function" or type(cb) == "table" then
        args[#args] = nil --remove callback from table
    else
        cb = function() end
    end

    for _,v in ipairs(events[eventName]) do
        local cbArgs = {v(table.unpack(args))}
        cb(table.unpack(cbArgs))
    end
end

exports("TriggerCallbackEvent", TriggerCallbackEvent)

function TriggerServerCallbackEvent(eventName, ...)
    local args = {...}
    local cb = args[#args]

    if type(cb) == "function" or type(cb) == "table" then
        args[#args] = nil --remove callback from table
    else
        cb = function() print("^1Undefined callback for: " .. eventName .. "!^0") end
    end
    
    TriggerServerEvent("event_callback:receiveFromClient", eventName, table.unpack(args))

    local cookie = 0
    cookie = AddStateBagChangeHandler(eventName .. ":client", nil, function(bagName, key, value)
        if not value then return end --State bag value is equal to nil

        for _,v in ipairs(value) do
            CreateThread(function()
                cb(table.unpack(v))
            end)
        end

        RemoveStateBagChangeHandler(cookie)
    end)

end

exports("TriggerServerCallbackEvent", TriggerServerCallbackEvent)