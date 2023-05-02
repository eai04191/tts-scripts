-- ObjectのGMNotesのjsonをパースしてvalueを取得する
function Object_getValue(o)
    local json = o.getGMNotes()
    local value = JSON.decode(json)['value']

    return value
end

-- Object_getValueのcontainerのgetObjects()で取得できるtable版
function Object_getValue_container(t)
    local json = t.gm_notes
    local value = JSON.decode(json)['value']

    return value
end
