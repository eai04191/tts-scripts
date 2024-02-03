require("eai/util/mergeTables")

function onLoad()
    -- MDIからSize 64px, Padding 2dpで作成
    self.UI.setCustomAssets({
        {
            name = "lock",
            -- https://pictogrammers.com/library/mdi/icon/lock-outline/
            url = "http://cloud-3.steamusercontent.com/ugc/2074514228568208854/AA8D241F895100395C20D78536C5F1F758DBFB7F/"
        },
        {
            name = "unlock",
            -- https://pictogrammers.com/library/mdi/icon/lock-open-variant-outline/
            url = "http://cloud-3.steamusercontent.com/ugc/2074514228568208956/4A3BA9FB6F9A37644400C81E24D1B5DDF45703F4/"
        }
    })

    updateTextDisplay()
    updateButtonDisplay()
end

function updateTextDisplay()
    -- lock時: 非表示。カーソルが乗っていたらTextLockを表示
    -- unlock時: つねにTextUnlockを表示
    if (self.locked) then
        self.UI.hide("TextLock")
        self.UI.hide("TextUnlock")
    else
        self.UI.hide("TextLock")
        self.UI.show("TextUnlock")
    end
end

function onLockButtonEnter()
    self.UI.show("TextLock")
end

function onLockButtonExit()
    self.UI.hide("TextLock")
end

function updateButtonDisplay()
    if (self.locked) then
        self.UI.show("ButtonLock")
        self.UI.hide("ButtonUnlock")
    else
        self.UI.hide("ButtonLock")
        self.UI.show("ButtonUnlock")
    end
end

function onButton()
    local scale = self.getScale()
    local zoneParam = {
        type = 'ScriptingTrigger',
        -- 自身の左側に配置
        position = self.positionToWorld({
            x = 2.3,
            y = 0,
            z = 0,
        }),
        rotation = self.getRotation(),
        scale = { scale.x / 2, 1, scale.z * 2 },
    }

    local function unlockCallback(zone)
        zone.addTag("ChipSpawner")

        for _, o in ipairs(zone.getObjects()) do
            -- 自身にタグがついているので同じタグがついているものだけがoとして取れるはずだが、何故かそうならないのでここでも判別する
            if not o.hasTag("ChipSpawner") then
                goto continue
            end

            self.addAttachment(o)
            ::continue::
        end

        zone.destruct()
    end

    local function lockCallback(zone)
        zone.addTag("ChipSpawner")

        self.removeAttachments()

        for _, o in ipairs(zone.getObjects()) do
            if not o.hasTag("ChipSpawner") then
                goto continue
            end

            o.setLock(true)
            ::continue::
        end

        zone.destruct()
    end

    if (self.locked) then
        -- unlock
        self.setLock(false)
        spawnObject(mergeTables(zoneParam, { callback_function = unlockCallback }))
    else
        -- lock
        self.setLock(true)
        spawnObject(mergeTables(zoneParam, { callback_function = lockCallback }))
    end

    updateTextDisplay()
    updateButtonDisplay()
end
