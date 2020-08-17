-- The script based on WorkerRecaller by 4LDK
-- https://steamcommunity.com/sharedfiles/filedetails/?id=1235212163

config = {
    climedColor = nil
}

function onLoad()
    self.createButton(
        {
            click_function = "claim",
            label = "Claim",
            function_owner = self,
            position = {-2.75, 0.1, -8.5},
            rotation = {0, -90, 0},
            width = 1000,
            height = 650,
            font_size = 150
        }
    )
    savePosition()
end

function claim(_, color)
    -- Claimボタンを削除
    self.removeButton(0)

    config.climedColor = color
    self.setColorTint(config.climedColor)

    self.createButton(
        {
            click_function = "savePosition",
            label = "Save Position",
            function_owner = self,
            position = {-3.1, 0.1, -8.5},
            rotation = {0, -90, 0},
            width = 1000,
            height = 300,
            font_size = 150
        }
    )
    self.createButton(
        {
            click_function = "recall",
            label = "Recall",
            function_owner = self,
            position = {-2.4, 0.1, -8.5},
            rotation = {0, -90, 0},
            width = 1000,
            height = 300,
            font_size = 150
        }
    )
end

function savePosition(_, color)
    -- 所有者チェック
    if isColorWhoPressedTheButtonAClaimedColor(color) == false then
        return
    end

    startLuaCoroutine(self, "savePositionCoroutine")
end

function savePositionCoroutine()
    obj = {}
    objPosition = {}
    objRotation = {}
    createScriptZone()
    objInZone = scriptZone.getObjects()

    for i, objLoop in ipairs(objInZone) do
        if objLoop ~= self then
            table.insert(obj, objLoop)
            table.insert(objPosition, objLoop.getPosition())
            table.insert(objRotation, objLoop.getRotation())
        end
    end
    return 1
end

function recall(_, color)
    -- 所有者チェック
    if isColorWhoPressedTheButtonAClaimedColor(color) == false then
        return
    end

    if obj == nil then
        return
    end

    for i = 1, #obj do
        obj[i].setPositionSmooth(objPosition[i], false, true)
        obj[i].setRotationSmooth(objRotation[i], false, true)
    end
end

-- ボタンを押した色がボードの所有者の色か確認する関数
function isColorWhoPressedTheButtonAClaimedColor(color)
    if config.climedColor == color then
        return true
    else
        broadcastToColor("人のボードを操作してはいけません！", color)
        return false
    end
end

function createScriptZone()
    if scriptZone ~= nil then
        scriptZone.destruct()
        coroutine.yield(0)
    end

    scriptZone =
        spawnObject(
        {
            type = "ScriptingTrigger",
            position = self.getPosition(),
            rotation = self.getRotation(),
            scale = self.getBoundsNormalized().size
        }
    )
    coroutine.yield(0)
end
