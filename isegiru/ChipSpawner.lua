require("eai/isegiru/guid")
require("eai/isegiru/announce")
require("eai/isegiru/vector")
require("eai/util/string")

function getValue()
    local tags = self.getTags()
    for _, tag in ipairs(tags) do
        if starts_with(tag, "Value_") then
            -- Value_n から n を取り出す
            return string.sub(tag, 7)
        end
    end
    return "1"
end

function onLoad()
    local value = getValue()

    self.createButton({
        label = "",
        click_function = "buttonPressed",
        tooltip = value .. "チップを作成する",
        function_owner = self,
        position = { 0, 0.1, 0 },
        height = 700,
        width = 700
    })
end

function buttonPressed(_, playerColor)
    local value = getValue()

    announceToAll(playerColor, string.format("%sチップを作成しました", value))

    local targetObj = getObjectFromGUID(GUID["Chip" .. value])
    local targetObjScale = targetObj.getScale()

    -- 真上にスポーン
    local outObj = targetObj.clone({
        position = self.getPosition() + Vector({ 0, 1, 0 }),
        rotation = self.getRotation(),
        -- tokenの仕様上、ここではyは1固定
        scale = Vector({ 0.01, 1, 0.01 }),
    })

    -- 左上に飛ばす力を加える
    Wait.frames(function()
        outObj.addForce(VectorOnLeft(3, 12))
        outObj.addTorque(Vector({ 0, 0, 0.025 }))
    end, 3)

    -- インタラクティブの設定
    -- 真上に出る都合上連打してつかむとうざいので、出してすぐは触れないようにする
    Wait.frames(function()
        outObj.interactable = false
    end, 3)
    Wait.frames(function()
        outObj.interactable = true
    end, 16)

    scaleAnimation(outObj, targetObjScale)
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
