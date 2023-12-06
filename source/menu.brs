FUNCTION Menu()
    screen = CreateObject("roScreen", true, 1280, 720)
    buttonimage = CreateObject("roBitmap", "pkg:/images/number.png")
    highlightimage = CreateObject("roBitmap", "pkg:/images/HIGHLIGHT.png")
    logoimage = CreateObject("roBitmap", "pkg:/images/logo.png")
    walls = Wall()
    walls.SetImage("pkg:/images/WallSprites.png")
    buttons = []
    FOR i = 0 TO 7
        buttons.append(CreateObject("roRegion", buttonimage, i * 100, 0, 100, 100))
    END FOR
    msg = CreateObject("roMessagePort")
    screen.SetMessagePort(msg)
    ipt = InputTracker()
    Input(msg.GetMessage(), ipt)
    eject = false
    selected = 1
    WHILE NOT eject
        screen.Clear()
        screen.DrawObject(logoimage, 0, (screen.GetHeight() - logoimage.GetHeight()) / 2)
        FOR x = 0 TO 1
            FOR y = 0 TO 3
                IF(x + y * 2 = selected - 1)
                    screen.DrawObject(highlightimage, 100 + x * 300, 100 + y * 100)
                END IF
                screen.DrawObject(buttons[x + y * 2], 100 + x * 300, 100 + y * 100 + 50 * x)
            END FOR
        END FOR
    END WHILE

END FUNCTION
FUNCTION inputStep(port, selected)

END FUNCTION