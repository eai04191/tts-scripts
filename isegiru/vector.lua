function Vector_rotateVector(vector)
    local rotation = self.getRotation()
    local radX = math.rad(rotation.x)
    local radY = math.rad(rotation.y)
    local radZ = math.rad(rotation.z)

    local rx = {
        x = vector.x,
        y = math.cos(radX) * vector.y - math.sin(radX) * vector.z,
        z = math.sin(radX) * vector.y + math.cos(radX) * vector.z
    }

    local ry = {
        x = math.cos(radY) * rx.x + math.sin(radY) * rx.z,
        y = rx.y,
        z = -math.sin(radY) * rx.x + math.cos(radY) * rx.z
    }

    local rz = {
        x = math.cos(radZ) * ry.x - math.sin(radZ) * ry.y,
        y = math.sin(radZ) * ry.x + math.cos(radZ) * ry.y,
        z = ry.z
    }

    return Vector(rz)
end

function Vector_onTopLeft(force, forceY)
    return Vector_rotateVector(Vector({ x = force, y = forceY, z = -force }))
end

function Vector_onTopRight(force, forceY)
    return Vector_rotateVector(Vector({ x = -force, y = forceY, z = -force }))
end

function Vector_onBottomLeft(force, forceY)
    return Vector_rotateVector(Vector({ x = force, y = forceY, z = force }))
end

function Vector_onBottomRight(force, forceY)
    return Vector_rotateVector(Vector({ x = -force, y = forceY, z = force }))
end

function Vector_onTop(force, forceY)
    return Vector_rotateVector(Vector({ x = 0, y = forceY, z = -force }))
end

function Vector_onBottom(force, forceY)
    return Vector_rotateVector(Vector({ x = 0, y = forceY, z = force }))
end

function Vector_onLeft(force, forceY)
    return Vector_rotateVector(Vector({ x = force, y = forceY, z = 0 }))
end

function Vector_onRight(force, forceY)
    return Vector_rotateVector(Vector({ x = -force, y = forceY, z = 0 }))
end
