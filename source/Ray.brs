FUNCTION XRay(px, py, dx, dy, map)
    rayOut = Vector2()

    IF(abs(dx) < 0.1) THEN
        rayOut.x = -1
        rayOut.y = -1
        RETURN rayOut
    END IF

    xrayx = px
    xrayy = py
    deltaX = 0
    deltaY = 0
    found = false
    dis = 0

    IF(dx < 0) THEN
        stepmodx = px - int(px) + .01
    ELSE
        stepmodx = 1 + int(px) - px
    END IF

    deltax = xrayx + (dx * stepmodx / abs(dx))
    deltaY = xrayy + (dy * stepmodx / abs(dx))

    WHILE(NOT found)

        mp = map.Get(deltax, deltaY)

        IF(mp > 0) THEN
            found = true
        ELSE IF (mp < 0) THEN
            rayOut.x = -1
            rayOut.y = -1
            RETURN rayOut
        ELSE
            dis += 1
            deltax = xrayx + (dx * (stepmodx + dis) / abs(dx))
            deltaY = xrayy + (dy * (stepmodx + dis) / abs(dx))
        END IF
    END WHILE

    rayOut.x = deltax
    rayOut.y = deltaY
    RETURN rayOut
END FUNCTION

FUNCTION YRay(px, py, dx, dy, map)
    rayOut = Vector2()

    IF(abs(dy) < 0.1) THEN
        rayOut.x = -1
        rayOut.y = -1
        RETURN rayOut
    END IF

    yrayx = px
    yrayy = py
    deltaX = 0
    dis = 0
    deltaY = 0
    found = false

    IF(dy < 0) THEN
        stepmody = py - int(py) + .01
    ELSE
        stepmody = 1 + int(py) - py
    END IF

    deltaY = yrayy + (dy * stepmody / abs(dy))
    deltaX = yrayx + (dx * stepmody / abs(dy))

    WHILE(NOT found)
        mp = map.Get(deltaX, deltaY)

        IF(mp > 0) THEN
            found = true
        ELSE IF (mp < 0) THEN
            rayOut.x = -1
            rayOut.y = -1
            RETURN rayOut
        ELSE
            dis += 1
            deltaY = yrayy + (dy * (stepmody + dis) / abs(dy))
            deltaX = yrayx + (dx * (stepmody + dis) / abs(dy))
        END IF
    END WHILE
    rayOut.x = deltaX
    rayOut.y = deltaY
    RETURN rayOut
END FUNCTION

FUNCTION Distance(x1, y1, x2, y2)
    d = sqr((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
    RETURN d
END FUNCTION

FUNCTION Rotate(dx, dy, degrees)
    sin = Sin(degrees * .01745329)
    cos = Cos(degrees * .01745329)
    nv = Vector2()
    nv.x = (cos * dx) - (sin * dy)
    nv.y = (sin * dx) + (cos * dy)
    RETURN nv
END FUNCTION

FUNCTION Unfish(px, py, dx, dy, hx, hy, rx, ry)
    dis = Distance(px, py, hx, hy)
    a = abs(dis * Cos(FindDIFferenceRadians(dx, dy, rx, ry)))
    RETURN a
END FUNCTION

FUNCTION FindDIFferenceRadians(ax, ay, bx, by)
    y = aY - bY
    x = aX - bX
    r = Atn((y + .0001) / (x + .0001))
    r = r MOD 2 * 3.14
    RETURN r
END FUNCTION

FUNCTION Vector2()
    obj = {
        x: 0,
        y: 0,
    }
    RETURN obj
END FUNCTION

FUNCTION RayCheck(px, py, tx, ty, map)
    dx = tx - px
    dy = ty - py
    dis = Distance(px, py, tx, ty)
    dx = dx / dis
    dy = dy / dis
    FOR i = 0 TO dis
        pt = map.Get(px + (dx * i), py + (dy * i))
        IF pt > 3 AND pt <= 6 AND dis < 2 THEN
            RETURN true
        ELSE IF pt > 0 THEN
            RETURN false
        END IF
    END FOR
    RETURN true
END FUNCTION

FUNCTION VectorAngleDegrees(x1, y1, x2, y2)
    ' Calculate the dot product of the two vectors
    dotProduct = x1 * x2 + y1 * y2

    ' Calculate the magnitude (length) of each vector
    mag1 = SQR(x1 ^ 2 + y1 ^ 2)
    mag2 = SQR(x2 ^ 2 + y2 ^ 2)

    ' Calculate the cosine of the angle between the vectors
    cosine = dotProduct / (mag1 * mag2)

    ' Calculate the angle in radians
    angleRadians = ACOS(cosine)

    ' Convert the angle from radians to degrees
    angleDegrees = angleRadians * 180 / 3.14159265
    cross = x1 * y2 - y1 * x2
    IF cross > 0 THEN
        angleDegrees = -angleDegrees
    END IF
    ' Return the result
    RETURN angleDegrees
END FUNCTION
FUNCTION ACOS(x)
    IF (SQR(-x * x + 1) = 0)
        RETURN 0
    ELSE
        RETURN ATN(-x / SQR(-x * x + 1)) + 2 * ATN(1)
    END IF
END FUNCTION
