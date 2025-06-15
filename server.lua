local events = {}

RegisterNetEvent('event_callback:receiveFromClient')

AddEventHandler('event_callback:receiveFromClient', function(eventName, ...)
    local src = source
    if not events[eventName] then print("^1The callback event: " .. eventName .. " doesn't exist!^0"); return end
    if not DoesPlayerExist(src) then print("^1The Player source: " .. src .. " doesn't exist!^0"); return end

    local cbArgs = {}

    for _,v in ipairs(events[eventName]) do
        cbArgs[#cbArgs+1] = {v(...)}
    end

    Player(src).state:set(eventName .. ":client", nil, true) --to reset state bag
    Player(src).state:set(eventName  .. ":client", cbArgs, true)
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
    if type(handler) ~= "function" and type(handler) ~= "table"  then print("^1The handler of the callback event: " .. eventName .. " is not a function!^0"); return end
    
    events[eventName][#events[eventName]] = handler
end

exports("AddCallbackEventHandler", AddCallbackEventHandler)

function TriggerCallbackEvent(eventName, ...)
    if not events[eventName] then print("^1The callback event: " .. eventName .. " doesn't exist!^0"); return end

    local args = {...}
    local cb = args[#args]

    if type(cb) == "function" or type(cb) == "table" then
        args[#args] = nil --remove callback from table
    else
        cb = function() print("^1Undefined callback for: " .. eventName .. "!^0") end
    end

    for _,v in ipairs(events[eventName]) do
        local cbArgs = {v(table.unpack(args))}
        cb(table.unpack(cbArgs))
    end
end

exports("TriggerCallbackEvent", TriggerCallbackEvent)

function TriggerClientCallbackEvent(eventName, source, ...)
    if type(source) ~= "number" or (not DoesPlayerExist(source) and source ~= -1) then print("^1The player source " .. source .. " doesn't exist!^0"); return end

    local args = {...}
    local cb = args[#args]

    if type(cb) == "function" or type(cb) == "table" then
        args[#args] = nil --remove callback from table
    else
        cb = function() end
    end
    
    TriggerClientEvent("event_callback:receiveFromServer", source, eventName, table.unpack(args))

    local cookie = 0
    cookie = AddStateBagChangeHandler(eventName .. ":server", nil, function(bagName, key, value)
        if not value then return end --State bag value is equal to nil

        local player = GetPlayerFromStateBagName(bagName)
        if not DoesPlayerExist(player) then print("^1Player: " .. player .. " doesn't exist!^0"); return end 

        for _,v in ipairs(value) do
            CreateThread(function()
                cb(table.unpack(v))
            end)
        end

        RemoveStateBagChangeHandler(cookie)
    end)

end

exports("TriggerClientCallbackEvent", TriggerClientCallbackEvent)