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

    self.UI.hide("TextLock")
    self.UI.hide("TextUnlock")
    updateButtonDisplay()
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
    if (self.locked) then
        self.setLock(false)
    else
        self.setLock(true)
    end
    updateButtonDisplay()
end

function onButtonEnter()
    if (self.locked) then
        self.UI.show("TextLock")
        self.UI.hide("TextUnlock")
    else
        self.UI.hide("TextLock")
        self.UI.show("TextUnlock")
    end
end

function onButtonExit()
    self.UI.hide("TextLock")
    self.UI.hide("TextUnlock")
end
