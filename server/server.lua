local UserTable = {}
local DefaultIdentifier = 'license'
local RejectReason = 'Your connection to the server has been rejected. Your identifier is already in use!'
local Debug = true


sprint = function(string)
    string = string or 'Not Available'

    if Debug then 
        print(string.format('%s - %s', GetCurrentResourceName(), string))
    end
end

AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    local src = source 
    local identifier = GetPlayerIdentifierByType(src, DefaultIdentifier)

    deferrals.defer()
    
    Wait(0)

    deferrals.update(string.format('Hello %s, Checking If Identifiers Are In Use...', name))

    if not identifier then 
        deferrals.done(string.format('Connection has been rejected to missing identifier: %s', DefaultIdentifier))
    else 
    if not UserTable[identifier] then 
        deferrals.done()  
    else
        deferrals.done(RejectReason)
        sprint(string.format('%s - Connection was rejected (identifier is in use)', name))
    end
end
end)

AddEventHandler("playerJoining", function()
    local src = source 
    local identifier = GetPlayerIdentifierByType(src, DefaultIdentifier)

    if UserTable[identifier] then 
        Wait(1)
        sprint(string.format('%s - Connection was rejected (identifier is in use)', GetPlayerName(src)))
        DropPlayer(src, RejectReason)
    else
        UserTable[identifier] = src
    end
end)

AddEventHandler('playerDropped', function(reason)
    local src = source 
    local identifier = GetPlayerIdentifierByType(src, DefaultIdentifier)

    if UserTable[identifier] and UserTable[identifier] == src then 
        UserTable[identifier] = nil
    end
end)