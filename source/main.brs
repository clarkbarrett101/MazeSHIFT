SUB Main()
    level = [Level_0(), Level_1(), Level_2(), Level_3(), Level_4()]
    levelindex = 4
    Menu()
    WHILE true
        StartLevel(level[levelindex])
        levelindex += 1
    END WHILE
END SUB

FUNCTION StartLevel(level)
    timer = CreateObject("roTimespan")
    timer.Mark()
    screen = CreateObject("roScreen", true, 1280, 720)
    map1 = World()
    map2 = World()
    map1.Set(level.wallsA)
    map1.SetMap()
    map2.Set(level.wallsB)
    map2.SetMap()
    map1.roof = ColorCode(level.ColorsA[0])
    map1.roof.Tone(.2)
    map1.floor = ColorCode(level.ColorsA[0])
    map1.floor.Tone(.1)
    map2.roof = ColorCode(level.ColorsB[0])
    map2.roof.Tone(.2)
    map2.floor = ColorCode(level.ColorsB[0])
    map2.floor.Tone(.1)

    walls1 = []
    walls2 = []
    FOR i = 0 TO 2
        walls1.Push(Wall())
        walls1[i].SetImage("pkg:/images/WallSprites.png", level.ColorsA[i])
        walls2.Push(Wall())
        walls2[i].SetImage("pkg:/images/WallSprites.png", level.ColorsB[i])
    END FOR
    walls1.Push(Wall())
    walls1[3].SetImage("pkg:/images/lockA.png", 0)
    walls2.Push(Wall())
    walls2[3].SetImage("pkg:/images/lockA.png", 0)
    walls1.Push(Wall())
    walls1[4].SetImage("pkg:/images/lockB.png", 0)
    walls2.Push(Wall())
    walls2[4].SetImage("pkg:/images/lockB.png", 0)
    walls1.Push(Wall())
    walls1[5].SetImage("pkg:/images/lockC.png", 0)
    walls2.Push(Wall())
    walls2[5].SetImage("pkg:/images/lockC.png", 0)
    walls1.Push(Wall())
    walls1[6].SetImage("pkg:/images/Xblock.png", 0)
    walls2.Push(Wall())
    walls2[6].SetImage("pkg:/images/Xblock.png", 0)
    walls1.Push(Wall())
    walls1[7].SetImage("pkg:/images/Oblock.png", 0)
    walls2.Push(Wall())
    walls2[7].SetImage("pkg:/images/Oblock.png", 0)

    player = Actor()
    player.SetPos(map1.playerPos[0], map1.playerPos[1])
    player.SetDir(-1, 0)
    msg = CreateObject("roMessagePort")
    screen.SetMessagePort(msg)
    ipt = InputTracker()
    screen.SetAlphaEnable(true)
    canvas = createObject("roBitmap", { Width: screen.GetWidth(), Height: screen.GetHeight(), AlphaEnable: true })
    shiftable = false
    cmap = map1
    cwalls = walls1
    omap = map2
    owalls = walls2
    mapA = true
    map1.otherMap = map2
    map2.otherMap = map1
    shiftIconA = CreateObject("roBitmap", "pkg:/images/ShiftIconA.png")
    shiftIconB = CreateObject("roBitmap", "pkg:/images/ShiftIconB.png")
    dpadIcon = CreateObject("roBitmap", "pkg:/images/Dpad.png")
    keyIcons = [CreateObject("roBitmap", "pkg:/images/key1.png"), CreateObject("roBitmap", "pkg:/images/key2.png"), CreateObject("roBitmap", "pkg:/images/key3.png")]
    WHILE player.eject = false
        IF(omap.get(player.px, player.py) = 0)
            player.shiftable = true
        ELSE
            player.shiftable = false
        END IF
        canvas.Clear(ColorCode(0).Get())
        Input(msg.GetMessage(), ipt)
        IF player.shift
            player.shift = false
            mapA = NOT mapA
            mp = cmap
            cmap = omap
            omap = mp
            wl = cwalls
            cwalls = owalls
            owalls = wl
        END IF

        Update(player, canvas, timer.TotalMilliSeconds() / 1000, cmap, ipt, cwalls)
        DrawDpad(canvas, dpadIcon)
        DrawKeys(canvas, player, keyIcons)
        IF player.shiftable
            IF mapA
                DrawShift(canvas, shiftIconA)
            ELSE
                DrawShift(canvas, shiftIconB)
            END IF
        END IF
        ' PRINT(1 / (timer.TotalMilliSeconds() / 1000))
        timer.Mark()

        canvas.finish()
        screen.DrawObject(0, 0, canvas)
        screen.SwapBuffers()
    END WHILE
END FUNCTION

FUNCTION Update(player, screen, deltaTime AS float, map, ipt, walls)
    moveSpeed = 20
    turnSpeed = 500
    CastView(map, player, screen, walls, player.fov)

    IF player.transition
        IF player.fov < 150
            player.fov += 1440 * deltaTime
        ELSE
            blink = CreateObject("roAudioResource", "navmulti")
            blink.trigger(50)
            player.fov = 150
            player.shift = true
            player.transition = false
        END IF
    ELSE IF player.fov > 45
        player.fov -= 1440 * deltaTime
    ELSE
        player.fov = 45
    END IF

    IF ipt.U AND NOT map.get(player.px + player.dx * .5, player.py + player.dy * .5) > 0
        player.Move(deltaTime * moveSpeed * player.moveAccel)
        IF player.moveAccel < 2
            player.moveAccel += deltaTime * 8
        END IF
    ELSE
        player.moveAccel = 1
    END IF
    IF ipt.D AND NOT map.get(player.px - player.dx * .5, player.py - player.dy * .5) > 0
        player.Move(-deltaTime * moveSpeed)
    END IF
    IF ipt.L OR ipt.R
        IF player.turnAccel < 2
            player.turnAccel += deltaTime * 8
        END IF
        IF ipt.L
            d = Rotate(player.dx, player.dy, -deltaTime * turnSpeed * player.turnAccel)
            player.dx = d.x
            player.dy = d.y
        ELSE IF ipt.R
            d = Rotate(player.dx, player.dy, deltaTime * turnSpeed * player.turnAccel)
            player.dx = d.x
            player.dy = d.y
        END IF
    ELSE
        player.turnAccel = 1
    END IF
    IF ipt.shift AND player.shiftable
        player.transition = true
        ipt.shift = false
    END IF
    IF ipt.interact AND player.interactable
        ipt.interact = false
        bleep = CreateObject("roAudioResource", "select")
        bleep.trigger(50)
        player.interactPawn.interaction(player, map)
    END IF
END FUNCTION

FUNCTION Actor()
    obj = {
        blink: 0
        bleep: 0
        SetSounds: FUNCTION(b, l) : blink = b : bleep = l : RETURN obj : END FUNCTION
        px: 0
        py: 0
        dx: 0
        dy: 0
        moveAccel: 1
        turnAccel: 1
        transition: false
        shift: false
        shiftable: false
        fov: 45
        eject: false
        interactable: false
        interactPawn: 0
        switch: true
        keys: [false, false, false]
        SetPos: FUNCTION(x, y) : m.px = x : m.py = y : RETURN obj : END FUNCTION
        SetDir: FUNCTION(x, y) : m.dx = x : m.dy = y : RETURN obj : END FUNCTION
        Move: FUNCTION(speed) : m.px += m.dx * speed : m.py += m.dy * speed : RETURN obj : END FUNCTION
    }
    RETURN obj
END FUNCTION

FUNCTION Input(msg, ipt)
    IF type(msg) = "roUniversalControlEvent"
        IF msg.GetInt() = 2
            ipt.u = true
        END IF
        IF msg.GetInt() = 3
            ipt.D = true
        END IF
        IF msg.GetInt() = 4
            ipt.l = true
        END IF
        IF msg.GetInt() = 5
            ipt.r = true
        END IF
        IF msg.GetInt() = 6
            ipt.shift = true
        END IF
        IF msg.GetInt() = 13
            ipt.interact = true
        END IF
        IF msg.GetInt() = 102
            ipt.u = false
        END IF
        IF msg.GetInt() = 103
            ipt.d = false
        END IF
        IF msg.GetInt() = 104
            ipt.l = false
        END IF
        IF msg.GetInt() = 105
            ipt.r = false
        END IF
        IF msg.GetInt() = 106
            ipt.shift = false
        END IF
        IF msg.GetInt() = 113
            ipt.interact = false
        END IF
    END IF
END FUNCTION

FUNCTION InputTracker()
    obj = {
        U: false
        D: false
        L: false
        R: false
        shift: false
        interact: false
    }
    RETURN obj
END FUNCTION

FUNCTION DrawShift(screen, shiftIcon)
    screen.DrawObject(screen.GetWidth() - shiftIcon.GetWidth(), screen.GetHeight() - shiftIcon.GetHeight(), shiftIcon)
END FUNCTION

FUNCTION DrawDpad(screen, dpad)
    screen.DrawObject(0, screen.GetHeight() - dpad.GetHeight(), dpad)
END FUNCTION
FUNCTION DrawKeys(screen, player, keyIcons)
    IF player.keys[0]
        screen.DrawObject(screen.getwidth() * 1 / 4, 0, keyIcons[0])
    END IF
    IF player.keys[1]
        screen.DrawObject(screen.getwidth() * 2 / 4, 0, keyIcons[1])
    END IF
    IF player.keys[2]
        screen.DrawObject(screen.getwidth() * 3 / 4, 0, keyIcons[2])
    END IF
END FUNCTION

