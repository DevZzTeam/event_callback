# Event Callback Using State Bags

Event Callback is a **FiveM/RedM** script to **facilitate** the **creation** of event callbacks using **State Bags**

## Installation

Using **cmd**:
```bash
cd "YOUR_SERVER_PATH/resources"
git clone https://github.com/DevZzTeam/event_callback.git
```
Or you can just download the reposite and put it in your **resources** folder

add this line in your server.cfg
```lua
ensure event_callback
```

## Usage
In your fivem script add this line in your fxmanifest.lua
```lua
dependency 'event_callback'
```
Now we can start, in your client file add these lines
```lua
RegisterNetCallbackEvent = function(eventName, handler) exports.event_callback:RegisterNetCallbackEvent(eventName, handler) end
AddCallbackEventHandler = function(eventName, handler) exports.event_callback:AddCallbackEventHandler(eventName, handler) end
TriggerCallbackEvent = function(eventName, ...) exports.event_callback:TriggerCallbackEvent(eventName, ...) end
TriggerServerCallbackEvent = function(eventName, ...) exports.event_callback:TriggerServerCallbackEvent(eventName, ...) end
```
these lines are created to facilitate the management of event callbacks, but you can also use
```lua
exports.event_callback:FUNCTION_NAME(eventName, arguments)
```
Now, in your server file add these lines
```lua
RegisterNetCallbackEvent = function(eventName, handler) exports.event_callback:RegisterNetCallbackEvent(eventName, handler) end
AddCallbackEventHandler = function(eventName, handler) exports.event_callback:AddCallbackEventHandler(eventName, handler) end
TriggerCallbackEvent = function(eventName, ...) exports.event_callback:TriggerCallbackEvent(eventName, ...) end
TriggerClientCallbackEvent = function(eventName, source, ...) exports.event_callback:TriggerClientCallbackEvent(eventName, source, ...) end
```
They're also created to facilitate the management of event callbacks.

Event Callback functions are very similar to the native functions, like
```lua
RegisterNetEvent()
AddEventHandler()
...
```
so the uses are similar!

Here is an example of a script using Event Callback:
```lua
--client.lua

RegisterNetCallbackEvent = function(eventName, handler) exports.event_callback:RegisterNetCallbackEvent(eventName, handler) end
AddCallbackEventHandler = function(eventName, handler) exports.event_callback:AddCallbackEventHandler(eventName, handler) end
TriggerCallbackEvent = function(eventName, ...) exports.event_callback:TriggerCallbackEvent(eventName, ...) end
TriggerServerCallbackEvent = function(eventName, ...) exports.event_callback:TriggerServerCallbackEvent(eventName, ...) end

local myName = "DevZzTeam"
local myAge = math.floor((math.random() * 100))

CreateThread(function()
    Wait(500) --Waiting for the creation of the callback event 'isInformationsValid' (on the server-side)
    TriggerServerCallbackEvent("isInformationsValid", myName, myAge, function(nameValid, ageValid)
        print(nameValid, ageValid)
    end)
end)
```
```lua
--server.lua

RegisterNetCallbackEvent = function(eventName, handler) exports.event_callback:RegisterNetCallbackEvent(eventName, handler) end
AddCallbackEventHandler = function(eventName, handler) exports.event_callback:AddCallbackEventHandler(eventName, handler) end
TriggerCallbackEvent = function(eventName, ...) exports.event_callback:TriggerCallbackEvent(eventName, ...) end
TriggerClientCallbackEvent = function(eventName, source, ...) exports.event_callback:TriggerClientCallbackEvent(eventName, source, ...) end

local blackListNames = {"unamed", "noname"}
local minAge = 18
local maxAge = 50

RegisterNetCallbackEvent("isInformationsValid", function(name, age)
    local invalidName = false
    local invalidAge = false

    for _,v in ipairs(blackListNames) do
        if name == v then
            invalidName = true
        end
    end

    if age < minAge or age > maxAge then
        invalidAge = true
    end

    return invalidName, invalidAge
end)
```

## License

[GNU](https://choosealicense.com/licenses/gpl-3.0/)
