DECKBAG_GUID = "6b5ba3"
DIE_GUID = "552cdf"

function onload()
    self.createButton(
        {
            label = "Deal",
            click_function = "deal",
            function_owner = self,
            position = {0, 1, 0},
            height = 1000,
            width = 1000,
            font_size = 300
        }
    )
    -- スクリプトによってroll()された場合onRandomizeイベントが発火しない
    -- self.createButton(
    --     {
    --         label = "Roll Die",
    --         click_function = "roll",
    --         function_owner = self,
    --         position = {0, 1, 2},
    --         height = 700,
    --         width = 1000,
    --         font_size = 250
    --     }
    -- )
end

-- function roll()
--     getObjectFromGUID(DIE_GUID).shuffle()
-- end

function deal()
    startLuaCoroutine(self, "dealCoroutine")
end

function dealCoroutine()
    local bag = getObjectFromGUID(DECKBAG_GUID)
    bag.shuffle()
    local boards = {}
    for _, playerColor in ipairs(getSeatedPlayers()) do
        local rot = Player[playerColor].getHandTransform().rotation
        local pos = Player[playerColor].getHandTransform().position
        -- ボードの出現高度
        pos.y = 1

        -- ボードz軸のオフセット
        local zOffset = 6
        if rot.y < 179 then
            pos.z = pos.z + zOffset
        else
            pos.z = pos.z - zOffset
        end

        -- 上下逆なのでひっくり返す
        rot.y = rot.y + 180
        bag.takeObject(
            {
                position = pos,
                rotation = rot,
                callback_function = function(board)
                    table.insert(boards, board)
                end
            }
        )
        -- local board = deck.dealToColorWithOffset({0, 0, 6}, false, playerColor)
        -- wait(0.5)
        -- board.rotate({x = 0, y = 180, z = 0})
    end

    wait(0.75)

    broadcastToAll("Ready")
    wait(0.5)
    broadcastToAll("Set")
    wait(0.5)
    getHost().pingTable({x = 0, y = -2, z = 0})
    broadcastToAll("GO!")

    gameStart = os.clock()

    for _, board in ipairs(boards) do
        board.flip()
    end

    wait(0.1)

    for _, board in ipairs(boards) do
        local pos_current = board.getPosition()
        board.setPositionSmooth({x = pos_current.x, y = 1, z = pos_current.z}, false, true)
        board.lock()
    end

    UI.setAttribute("ubongo_button", "interactable", "true")

    return 1
end

function ubongo_clicked(player, value, id)
    local spend = os.clock() - gameStart
    printToAll(string.format("%s: %.2f秒", player.steam_name, spend))
end

-- From: https://steamcommunity.com/sharedfiles/filedetails/?id=752690530
function wait(time)
    local start = os.time()
    repeat
        coroutine.yield(0)
    until os.time() > start + time
end

function getHost()
    local players = Player.getPlayers()
    for _, player in ipairs(players) do
        if player.host then
            return player
        end
    end
end
