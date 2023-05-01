function getPlayerFromColor(color)
    for _, player in ipairs(Player.getPlayers()) do
        if player.color == color then
            return player
        end
    end
    return nil
end

function announceToAll(color, message)
    local player = getPlayerFromColor(color)
    local shortPlayerName = "???  "
    local hex = "-"

    if color == "SYSTEM" then
        shortPlayerName = "SYSTEM"
        hex = "000000"
    end

    if player ~= nil then
        -- username max 5 chars
        shortPlayerName = string.sub(player.steam_name .. "     ", 1, 5)
        hex = Color[player.color]:toHex()
    end


    printToAll(string.format("[sup][%s]%s[/sup][-] %s", hex, shortPlayerName, message))
end
