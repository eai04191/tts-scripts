-- http://lua-users.org/wiki/StringRecipes
function starts_with(str, start)
    return str:sub(1, #start) == start
end

function ends_with(str, ending)
    return ending == "" or str:sub(- #ending) == ending
end
