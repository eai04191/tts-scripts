-- http://lua-users.org/wiki/StringRecipes
function String_starts_with(str, start)
    return str:sub(1, #start) == start
end

function String_ends_with(str, ending)
    return ending == "" or str:sub(- #ending) == ending
end
