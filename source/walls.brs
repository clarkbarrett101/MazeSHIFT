FUNCTION Wall()
    obj = {
        colors: [[], []]
        image: 0
        time: 0
        SetImage: FUNCTION(img, index)
            srcImg = CreateObject("roBitmap", img):
            m.image = CreateObject("roRegion", srcImg, 0, srcImg.GetWidth() * index, srcImg.GetWidth(), srcImg.GetWidth())
            m.time = CreateObject("roTimespan")
            m.time.Mark()
        END FUNCTION
        GetRegion: FUNCTION(section, fov)
            region = m.image.copy()
            region.SetWrap(true)
            region.SetScaleMode(0)
            region.OffSet(section * m.image.GetWidth() - (fov / 2) + m.time.TotalmilliSeconds() / 30, 0, fov - m.image.GetWidth(), 0)
            RETURN region
        END FUNCTION
    }
    RETURN obj
END FUNCTION

FUNCTION CastView(map, player, screen, walls, fov)
    raycount = 120
    screen.DrawRect(0, 0, screen.GetWidth(), screen.GetHeight(), map.roof.Get())
    screen.DrawRect(0, screen.GetHeight() / 2, screen.GetWidth(), screen.GetHeight() / 2, map.floor.get())
    hit = Vector2()
    FOR i = - (rayCount / 2) TO rayCount / 2
        d = Rotate(player.dx, player.dy, i * (fov / rayCount))
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
        fish = (Unfish(player.px, player.py, player.dx, player.dy, hit.x, hit.y, d.x, d.y) + 1)
        wallHeight = screen.GetHeight() * 2 / fish
        dso(i, rayCount, fish, walls, hit, player, screen, map)
    END FOR
    DrawPawns(map, player, screen, rayCount)
END FUNCTION

FUNCTION dso(i, raycount, fish, walls, hit, player, screen, map)
    d = Distance(player.px, player.py, hit.x, hit.y)
    idx = map.Get(hit.x, hit.y) - 1
    maxWidth = walls[idx].image.GetWidth() / raycount
    fov = maxWidth * fish
    wallHeight = screen.GetHeight() * 2 / fish
    region = walls[idx].GetRegion(hit.x - int(hit.x) + hit.y - int(hit.y), fov).copy()
    screen.DrawScaledObject(screen.GetWidth() / 2 + i * (screen.GetWidth() / rayCount), (screen.GetHeight() - wallHeight) / 2, .1 + (screen.GetWidth() / raycount) / fov, wallheight / region.GetHeight(), region)
END FUNCTION

FUNCTION DrawPawns(map, player, screen, rayCount)
    player.interactable = false
    FOR i = 0 TO map.pawns.Count() - 1
        dx = map.pawns[i].px - player.px
        dy = map.pawns[i].py - player.py
        dis = Distance(player.px, player.py, map.pawns[i].px, map.pawns[i].py)
        dx /= dis
        dy /= dis
        dr = VectorAngleDegrees(dx, dy, player.dx, player.dy) / (45 / rayCount)
        IF dr > -rayCount / 2 AND dr < rayCount / 2
            IF(RayCheck(player.px, player.py, map.pawns[i].px, map.pawns[i].py, map))
                h = screen.GetHeight() / Unfish(player.px, player.py, player.dx, player.dy, map.pawns[i].px, map.pawns[i].py, dx, dy)
                w = h / (map.pawns[i].image.GetHeight() / map.pawns[i].image.GetWidth())
                screen.DrawScaledObject((screen.GetWidth() / 2) + (dr * screen.GetWidth() / rayCount) - (h / 2), (screen.GetHeight() - h) / 2, w / map.pawns[i].image.GetWidth(), h / map.pawns[i].image.GetHeight(), map.pawns[i].image)
                IF(dis < 2)
                    icon = map.pawns[i].interactIcon
                    screen.DrawObject(screen.GetWidth() / 2 - icon.GetWidth() / 2, screen.GetHeight() - icon.GetHeight(), icon)
                    player.interactPawn = map.pawns[i]
                    player.interactable = true
                END IF
            END IF
        END IF
    END FOR
END FUNCTION