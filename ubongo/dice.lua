-- Based on https://www.reddit.com/r/tabletopsimulator/comments/b9wtny/dice_roll_announcer/

local side, text = "", ""
local randomized = false

function onRandomize(player_color)
    if not randomized then
        randomized = true
        startLuaCoroutine(self, "whileDrop")
    end
end

function whileDrop()
    while not self.resting do
        coroutine.yield(0) -- Always yield 0 to resume
    end
    randomized = false
    printDiceFace()
    coroutine.yield(1) -- Yield anything other than 0 to break out
end

function printDiceFace()
    local value = self.getValue()
    UI.setAttribute("ubongo_die", "image", value)
end
