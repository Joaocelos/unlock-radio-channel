-- Configuration
local config = {
    channels = {
        [1] = { -- Channel 1
            label = "Police Dispatch",
            locked = true,
            jobs = {
                ["police"] = true,
                ["sheriff"] = true,
            },
            gangs = {},
        },
    },
}

-- Function to unlock a channel
function unlockChannel(channel)
    if config.channels[channel].locked then
        local player = exports["qb-core"]:getModule("Player"):GetPlayerData(source)
        local job = player.job.name
        local gang = player.gang.name

        if config.channels[channel].jobs[job] or config.channels[channel].gangs[gang] then
            config.channels[channel].locked = false
            TriggerClientEvent("qb-radio:channelUnlocked", -1, channel)
            TriggerClientEvent("chat:addMessage", -1, {
                color = {255, 0, 0},
                args = {"Radio", config.channels[channel].label .. " channel has been unlocked!"}
            })
        else
            TriggerClientEvent("chat:addMessage", source, {
                color = {255, 0, 0},
                args = {"Radio", "You do not have permission to unlock " .. config.channels[channel].label .. " channel!"}
            })
        end
    else
        TriggerClientEvent("chat:addMessage", source, {
            color = {255, 0, 0},
            args = {"Radio", config.channels[channel].label .. " channel is already unlocked!"}
        })
    end
end

-- Register the command to unlock a channel
RegisterCommand("unlockradio", function(source, args)
    local channel = tonumber(args[1])

    if channel and config.channels[channel] then
        unlockChannel(channel)
    else
        TriggerClientEvent("chat:addMessage", source, {
            color = {255, 0, 0},
            args = {"Radio", "Invalid channel specified!"}
        })
    end
end)
