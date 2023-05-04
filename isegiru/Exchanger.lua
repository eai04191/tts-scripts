require("eai/isegiru/guid")
require("eai/isegiru/announce")
require("eai/isegiru/vector")
require("eai/isegiru/object")

local running = false

function onObjectEnterContainer(container, object)
    if container ~= self then
        return
    end

    if (running == false) then
        running = true

        -- 本当はユーザーが触らなくなってから１秒後にしたい

        Timer.create({
            identifier = self.getGUID(), function_name = 'mainProcess', delay = 0.5
        })
    end
end

function getCountAndTotalValueOfChips(table)
    local count = 0
    local totalValue = 0

    for _, subTable in pairs(table) do
        local value = Object_getValue_container(subTable)
        count = count + 1
        totalValue = totalValue + value
    end
    return { count = count, totalValue = totalValue }
end

function spawn(values)
    for k, value in ipairs(values) do
        local targetObj = getObjectFromGUID(GUID["Chip" .. value])
        local targetObjScale = targetObj.getScale()

        local outObj

        -- 真上にスポーン
        Wait.frames(function()
            outObj = targetObj.clone({
                position = self.getPosition() + Vector({ 0, 3.5, 0 }),
                rotation = self.getRotation(),
                -- tokenの仕様上、ここではyは1固定
                scale = Vector({ 0.01, 1, 0.01 }),
            })
            -- 左上に飛ばす力を加える
            Wait.frames(function()
                outObj.addForce(Vector_onLeft(3, 12))
                outObj.addTorque(Vector({ 0, 0, 0.025 }))
            end, 3)
            scaleAnimation(outObj, targetObjScale)
        end, 17 * k - 17) -- このフレームごとに1枚ずつ出す。同時に出すとぶつかるから
    end
end

function findClosestSum(input)
    local values = { 20, 10, 5, 2, 1 }
    local result = {}
    local remaining = input

    for i, value in ipairs(values) do
        while remaining >= value do
            table.insert(result, value)
            remaining = remaining - value
        end
    end

    return result
end

function mainProcess()
    local objects = self.getObjects()
    local countAndTotalValue = getCountAndTotalValueOfChips(objects)
    local count = countAndTotalValue.count
    local totalValue = countAndTotalValue.totalValue

    self.reset()

    if count == 1 then
        if totalValue == 1 then
            spawn({ 1 })
        elseif totalValue == 2 then
            spawn({ 1, 1 })
        elseif totalValue == 5 then
            spawn({ 2, 2, 1 })
        elseif totalValue == 10 then
            spawn({ 5, 5 })
        elseif totalValue == 20 then
            spawn({ 10, 10 })
        end
    else
        local sum = findClosestSum(totalValue)
        spawn(sum)
    end

    running = false
end

function onDestroy()
    Timer.destroy(self.getGUID())
end

function scaleAnimation(object, targetObjScale)
    -- スケールの設定
    -- 小さく出てから徐々に大きくする
    Wait.frames(function()
        object.setScale({ targetObjScale.x / 4, targetObjScale.y / 4, targetObjScale.z / 4 })
    end, 3)
    Wait.frames(function()
        object.setScale({ targetObjScale.x / 3, targetObjScale.y / 3, targetObjScale.z / 3 })
    end, 5)
    Wait.frames(function()
        object.setScale({ targetObjScale.x / 2.5, targetObjScale.y / 2.5, targetObjScale.z / 2.5 })
    end, 7)
    Wait.frames(function()
        object.setScale({ targetObjScale.x / 2, targetObjScale.y / 2, targetObjScale.z / 2 })
    end, 9)
    Wait.frames(function()
        object.setScale({ targetObjScale.x / 1.5, targetObjScale.y / 1.5, targetObjScale.z / 1.5 })
    end, 11)
    Wait.frames(function()
        object.setScale(targetObjScale)
    end, 13)
end
