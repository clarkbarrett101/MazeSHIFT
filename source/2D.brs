FUNCTION Cast2D(map, player, screen, walls)
    DrawMap(screen, map)
    rayCount = 5
    hit = Vector2()
    FOR i = - (rayCount / 2) TO rayCount / 2
        d = Rotate(player.dx, player.dy, i * (45 / rayCount))
        rayx = Xray(player.px, player.py, d.x, d.y, map)
        rayy = Yray(player.px, player.py, d.x, d.y, map)
        IF(rayx.x = -1) THEN
            hit.x = rayy.x
            hit.y = rayy.y
        ELSE IF(rayy.x = -1) THEN
            hit.x = rayx.x
            hit.y = rayx.y
        ELSE IF Distance(player.px, player.py, rayx.x, rayx.y) < Distance(player.px, player.py, rayy.x, rayy.y) THEN
            hit.x = rayx.x
            hit.y = rayx.y
        ELSE
            hit.x = rayy.x
            hit.y = rayy.y
        END IF
        s = "px:" + str(int(player.px * 10) / 10) + " py:" + str(int(player.py * 10) / 10) + " dx:" + str(int(player.dx * 10) / 10) + " dy:" + str(int(player.dy * 10) / 10) + " hitx:" + str(int(hit.x * 10) / 10) + " hity:" + str(int(hit.y * 10) / 10)
        PRINT(s)
        screen.DrawPoint(hit.X * 40, hit.Y * 40, 3, ColorCOde(7).Get())
        screen.DrawPoint(player.px * 40, player.py * 40, 3, ColorCOde(7).Get())
        screen.DrawPoint(player.px * 40 + player.dx * 5, player.py * 40 + player.dy * 5, 3, ColorCOde(7).Get())
        screen.DrawLine(player.px * 40, player.py * 40, hit.X * 40, hit.Y * 40, ColorCode(3).Get())
    END FOR
    Pawns2d(map, player, screen)
END FUNCTION
FUNCTION Pawns2d(map, player, screen)
    FOR i = 0 TO map.Pawns.Count() - 1
        IF(RayCheck(player.px, player.py, map.Pawns[i].px, map.Pawns[i].py, map)) THEN
            screen.DrawPoint(map.Pawns[i].px * 40, map.Pawns[i].py * 40, 10, ColorCode(7).Get())
            screen.DrawLine(player.px * 40, player.py * 40, map.Pawns[i].px * 40, map.Pawns[i].py * 40, ColorCode(2).Get())
        END IF
    END FOR
END FUNCTION
FUNCTION DrawMap(screen, mp)
    screen.DrawRect(0, 0, screen.GetWidth(), screen.GetHeight(), ColorCode(1).Get())
    FOR i = 0 TO mp.maxX - 1
        screen.DrawLine(i * 40, 0, i * 40, screen.GetHeight(), ColorCode(7).Get())
        FOR j = 0 TO mp.maxY - 1
            screen.DrawLine(0, j * 40, screen.GetWidth(), j * 40, ColorCode(7).Get())
            IF mp.mapDiscovered[i][j] = 0
                screen.DrawRect(i * 40, j * 40, 40, 40, ColorCode(7).Get())
            ELSE
                screen.DrawRect(i * 40, j * 40, 40, 40, ColorCode(0).Get())
            END IF
        END FOR
    END FOR
END FUNCTION