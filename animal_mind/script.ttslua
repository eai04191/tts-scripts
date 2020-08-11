deckGUID = "884865"
zoneGUID = "c972e6"
noteBase = "ANIMAL MIND\n\n[sub]Manual in the Notebook[/sub]\n\n\n\n"

function onload()
    createStartButton()
    Notes.setNotes(noteBase)
end

function onPlayerTurn()
    updateRemingCards()
end

function createStartButton()
    self.createButton(
        {
            label = "Game\nStart",
            click_function = "createDeck",
            function_owner = self,
            position = {0, 1, 0},
            height = 600,
            width = 600,
            font_size = 180
        }
    )
end

function createDeck()
    -- waitを入れるためにコルーチンで実行する
    startLuaCoroutine(self, "createDeckMain")
end

function createDeckMain()
    -- Start ボタンを机に下に移動させてボタンを消す
    self.lock()
    self.setPosition(Vector({0, -3, 0}))
    self.clearButtons()

    local deck = getObjectFromGUID(deckGUID)

    -- SoAを取り出す
    local cardsInDeck = deck.getObjects()
    local SoA_count = 0
    local SoA = {}
    for i, card in ipairs(cardsInDeck) do
        if card.nickname == "Settlement of Account" then
            local dp = deck.getPosition()
            table.insert(SoA, card.guid)
            deck.takeObject(
                {
                    -- position.x: 1枚目が左、2枚目が真ん中、3枚目が右になるように
                    -- position.z: 1,3枚目を傾けているので、まっすぐに見せるために2枚めを少し(0.5)奥にする
                    position = Vector(dp.x - 3 + SoA_count * 3, 4.5, (SoA_count == 1) and dp.z + 7.5 or dp.z + 7),
                    -- rotation.y: 20度ずつ傾ける
                    rotation = Vector(30, 160 + SoA_count * 20, 0),
                    guid = card.guid,
                    flip = true,
                    callback_function = function(card)
                        card.lock()
                    end
                }
            )
            SoA_count = SoA_count + 1
            wait(0.25)
        end
    end
    wait(0.5)

    -- 混ぜる
    deck.shuffle()
    wait(0.5)

    -- デッキを6つに割る
    local decks = deck.split(6)

    -- 移動させる
    -- position.z: -6.25 から 2.5刻みで 6.25 まで
    for i, d in ipairs(decks) do
        d.setPositionSmooth(Vector(0, decks[6].getPosition().y, -6.25 + (i - 1) * 2.5))
        d.setRotationSmooth(Vector(0, 90, 180))
    end
    wait(0.75)

    -- 枚数が少ないdecks6,5,4にSoAを入れて、混ぜる
    getObjectFromGUID(SoA[1]).unlock()
    decks[4].putObject(getObjectFromGUID(SoA[1]))
    wait(0.25)
    getObjectFromGUID(SoA[2]).unlock()
    decks[5].putObject(getObjectFromGUID(SoA[2]))
    wait(0.25)
    getObjectFromGUID(SoA[3]).unlock()
    decks[6].putObject(getObjectFromGUID(SoA[3]))
    wait(1)
    decks[4].shuffle()
    decks[5].shuffle()
    decks[6].shuffle()
    wait(0.5)

    -- [1]決算を含まない
    -- [4]決算を含む
    -- [2]決算を含まない
    -- [5]決算を含む
    -- [3]決算を含まない
    -- [6]決算を含む
    -- の順番で重ねていく
    -- putObjectで順番をよしなにできなかったので上から落として重ねる
    local p = decks[6].getPosition()
    -- ちょっと上げる
    p.y = p.y + 2
    decks[3].setPositionSmooth(p)
    wait(0.5)
    decks[5].setPositionSmooth(p)
    wait(0.5)
    decks[2].setPositionSmooth(p)
    wait(0.5)
    decks[4].setPositionSmooth(p)
    wait(0.5)
    decks[1].setPositionSmooth(p)
    -- 重なるまで待つ
    wait(1.75)

    -- 真ん中に戻す
    deck.setPositionSmooth(Vector({0, deck.getPosition().y, 0}))
    deck.setRotationSmooth(Vector(0, 180, 180))

    -- アナウンス
    broadcastToAll("GAME READY!")

    -- ターンを有効化
    Turns.enable = true

    updateRemingCards()

    return 1
end

function updateRemingCards()
    local deck = getObjectFromGUID(deckGUID)
    local cardsInDeck = deck.getObjects()
    local SoA_count = 0
    local EGG_count = {0, 0, 0}
    local MILK_count = {0, 0, 0}
    local WOOL_count = {0, 0, 0}
    local PET_count = {0, 0, 0}

    -- カウントを足す
    for i, card in ipairs(cardsInDeck) do
        -- 前方3文字
        local cardType = card.nickname:sub(0, 3)
        -- 後方1文字
        local cardScore = tonumber(card.nickname:sub(-1))

        if (cardType == "Set") then
            SoA_count = SoA_count + 1
        else
            local index = cardScore + 1
            if (cardType == "EGG") then
                EGG_count[index] = EGG_count[index] + 1
            elseif (cardType == "MIL") then
                MILK_count[index] = MILK_count[index] + 1
            elseif (cardType == "WOO") then
                WOOL_count[index] = WOOL_count[index] + 1
            elseif (cardType == "PET") then
                PET_count[index] = PET_count[index] + 1
            end
        end
    end

    note = noteBase .. "Reming Cards:\n[sup]Update with every turn start.[/sup]\n"
    note = note .. string.format("Settlement of Account: %d\n\n", SoA_count)
    note = note .. string.format("[b]0[/b]   [b]1[/b]   [b]2[/b]\n")
    note = note .. string.format("EGG:  %d   %d   %d\n", EGG_count[1], EGG_count[2], EGG_count[3])
    note = note .. string.format("MILK:  %d   %d   %d\n", MILK_count[1], MILK_count[2], MILK_count[3])
    note = note .. string.format("WOOL:  %d   %d   %d\n", WOOL_count[1], WOOL_count[2], WOOL_count[3])
    note = note .. string.format("PET:  %d   %d   %d\n", PET_count[1], PET_count[2], PET_count[3])

    Notes.setNotes(note)
end

-- From: https://steamcommunity.com/sharedfiles/filedetails/?id=752690530
function wait(time)
    local start = os.time()
    repeat
        coroutine.yield(0)
    until os.time() > start + time
end
