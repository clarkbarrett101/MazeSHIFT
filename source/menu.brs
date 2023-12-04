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
    WHILE NOT eject
        screen.Clear()

    END WHILE

END FUNCTION