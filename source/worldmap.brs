

FUNCTION World()
    obj = {
        otherMap: 0
        playerPos: [0, 0]
        exitPos: [0, 0]
        switches: [0, 0]
        switchCount: 0
        locks: [[0, 0], [0, 0]]
        lockCount: 0
        mapXs: [[0, 0], [0, 0]]
        mapXCount: 0
        mapOs: [[0, 0], [0, 0]]
        mapOCount: 0
        roof: 0
        floor: 0
        Set: FUNCTION(v2Array) :
            m.Pts = v2Array :
            m.maxX = m.Pts.Count()
            m.maxY = m.Pts[0].Count()
            RETURN obj :
        END FUNCTION
        Get: FUNCTION(x, y) :
            IF x < 0 OR y < 0 OR x >= m.maxX OR y >= m.maxY
                RETURN -1
            END IF
            RETURN m.Pts[INT(x)][INT(y)]:
        END FUNCTION
        GetV: FUNCTION(v) : RETURN m.Get(v.X, v.Y) : END FUNCTION
        Pts: [[0, 0], [0, 0]]
        AddPawn: FUNCTION(x, y, img, inteacttype, icon, keyIdx) :
            m.pawns[m.pawnIdx] = Pawn():
            m.pawns[m.pawnIdx].pawnidx = m.pawnIdx :
            m.pawns[m.pawnIdx].SetAll(x, y, img, inteacttype, icon, keyIdx) :
            m.pawnIdx++ :
            RETURN m.pawns[m.pawnIdx - 1] :
        END FUNCTION
        PawnUpdate: FUNCTION() :
            FOR i = 0 TO m.pawns.count() - 1
                m.pawns[i].pawnidx = i :
            END FOR
            RETURN obj :
        END FUNCTION
        SetMap: FUNCTION() :
            FOR i = 0 TO m.maxX - 1
                FOR j = 0 TO m.maxY - 1
                    pt = m.get(i, j)
                    IF pt = 9
                        m.playerPos = [i, j]
                        m.Pts[INT(i)][INT(j)] = 0 :
                    ELSE IF pt = 18
                        m.exitPos = [i, j]
                        m.Pts[INT(i)][INT(j)] = 0 :
                        m.AddPawn(i, j, "pkg:/images/exit.png", 3, "pkg:/images/exitIcon.png", 0) :
                    ELSE IF pt = 10
                        m.Pts[INT(i)][INT(j)] = 0 :
                        m.AddPawn(i, j, "pkg:/images/key1.png", 0, "pkg:/images/keyPickup.png", 0) :
                    ELSE IF pt = 11
                        m.Pts[INT(i)][INT(j)] = 0 :
                        m.AddPawn(i, j, "pkg:/images/key2.png", 0, "pkg:/images/keyPickup.png", 1) :
                    ELSE IF pt = 12
                        m.Pts[INT(i)][INT(j)] = 0
                        m.AddPawn(i, j, "pkg:/images/key3.png", 0, "pkg:/images/keyPickup.png", 2) :
                    ELSE IF pt = 4 :
                        m.AddPawn(i, j, "pkg:/images/empty.png", 1, "pkg:/images/unlock.png", 0) :
                        m.locks[m.lockCount] = [i, j] :
                        m.lockCount++ :
                    ELSE IF pt = 5
                        m.AddPawn(i, j, "pkg:/images/empty.png", 1, "pkg:/images/unlock.png", 1) :
                        m.locks[m.lockCount] = [i, j] :
                        m.lockCount++ :
                    ELSE IF pt = 6
                        m.AddPawn(i, j, "pkg:/images/empty.png", 1, "pkg:/images/unlock.png", 2) :
                        m.locks[m.lockCount] = [i, j] :
                        m.lockCount++ :
                    ELSE IF pt = 13
                        m.switches[m.switchCount] = m.AddPawn(i, j, "pkg:/images/Switch.png", 2, "pkg:/images/SwitchIcon.png", 0) :
                        m.switches[m.switchCount].image = CreateObject("roRegion", m.switches[m.switchCount].image, 132, 0, 132, 132) :
                        m.switches[m.switchCount].image.SetWrap(true)
                        m.switches[m.switchCount].interactIcon = CreateObject("roRegion", m.switches[m.switchCount].interactIcon, 0, 0, 132, 132) :
                        m.switches[m.switchCount].interactIcon.SetWrap(true)
                        m.switchCount++ :
                        m.Pts[INT(i)][INT(j)] = 0 :
                    ELSE IF pt = 7
                        m.mapXs[m.mapXCount] = [i, j]
                        m.mapXCount++ :
                    ELSE IF pt = 8
                        m.mapOs[m.mapOCount] = [i, j]
                        m.pts[INT(i)][INT(j)] = 0 :
                        m.mapOCount++ :
                    ELSE IF pt > 60
                        m.Pts[INT(i)][INT(j)] = 0 :
                    END IF
                END FOR
            END FOR : RETURN obj : END FUNCTION
            pawns: []
            pawnIdx: 0
            maxX: 0
            maxY: 0
        }
        RETURN obj
    END FUNCTION

    FUNCTION Pawn()
        obj = {
            px: 0
            py: 0
            Image: 0
            InteractType: 0
            Idx: 0
            pawnidx: 0
            interactIcon: 0
            SetAll: FUNCTION(x, y, img, interactType, icon, Idx) :
                m.px = x : m.py = y :
                m.image = CreateObject("roBitmap", img) :
                m.image.SetAlphaEnable(true) :
                m.InteractType = interactType :
                m.Idx = Idx :
                m.interactIcon = CreateObject("roBitmap", icon) :
                RETURN obj :
            END FUNCTION
            Interaction: FUNCTION(player, map) :
                IF m.InteractType = 0
                    m.KeyInteract(player, map)
                ELSE IF m.InteractType = 1
                    m.LockInteract(player, map)
                ELSE IF m.InteractType = 2
                    SwitchInteract(player, map)
                ELSE IF m.InteractType = 3
                    m.ExitInteract(player, map)
                END IF
            RETURN obj : END FUNCTION
            KeyInteract: FUNCTION(player, map) :
                player.keys[m.Idx] = true:
                map.pawns.Delete(int(m.pawnidx)):
                map.PawnUpdate()
            END FUNCTION
            LockInteract: FUNCTION(player, map) :
                lockpos = map.locks[m.Idx]
                IF player.keys[m.Idx]
                    map.Pts[INT(lockpos[0])][INT(lockpos[1])] = 0
                    map.pawns.delete(m.pawnidx)
                    map.PawnUpdate()
                END IF
            END FUNCTION
            ExitInteract: FUNCTION(player, map) :
                player.eject = true
            END FUNCTION
        }
        RETURN obj
    END FUNCTION
    FUNCTION SwitchInteract(player, map)
        IF player.switch
            FOR i = 0 TO map.mapXcount - 1
                map.Pts[INT(map.mapXs[i][0])][INT(map.mapXs[i][1])] = 0
            END FOR
            FOR i = 0 TO map.mapOcount - 1
                map.Pts[INT(map.mapOs[i][0])][INT(map.mapOs[i][1])] = 8
            END FOR
            FOR i = 0 TO map.switchcount - 1
                map.switches[i].image.OffSet(132, 0, 0, 0)
                map.switches[i].interactIcon.OffSet(132, 0, 0, 0)
            END FOR
            FOR I = 0 TO map.otherMap.mapXcount - 1
                map.otherMap.Pts[INT(map.otherMap.mapXs[i][0])][INT(map.otherMap.mapXs[i][1])] = 0
            END FOR
            FOR i = 0 TO map.otherMap.mapOcount - 1
                map.otherMap.Pts[INT(map.otherMap.mapOs[i][0])][INT(map.otherMap.mapOs[i][1])] = 8
            END FOR
            FOR i = 0 TO map.otherMap.switchcount - 1
                map.otherMap.switches[i].image.OffSet(132, 0, 0, 0)
                map.otherMap.switches[i].interactIcon.OffSet(132, 0, 0, 0)
            END FOR
            player.switch = false
        ELSE
            FOR i = 0 TO map.mapXcount - 1
                map.Pts[INT(map.mapXs[i][0])][INT(map.mapXs[i][1])] = 7
            END FOR
            FOR i = 0 TO map.mapOcount - 1
                map.Pts[INT(map.mapOs[i][0])][INT(map.mapOs[i][1])] = 0
            END FOR
            FOR i = 0 TO map.switchcount - 1
                map.switches[i].image.OffSet(132, 0, 0, 0)
                map.switches[i].interactIcon.OffSet(132, 0, 0, 0)
            END FOR
            FOR I = 0 TO map.otherMap.mapXcount - 1
                map.otherMap.Pts[INT(map.otherMap.mapXs[i][0])][INT(map.otherMap.mapXs[i][1])] = 7
            END FOR
            FOR i = 0 TO map.otherMap.mapOcount - 1
                map.otherMap.Pts[INT(map.otherMap.mapOs[i][0])][INT(map.otherMap.mapOs[i][1])] = 0
            END FOR
            FOR i = 0 TO map.otherMap.switchcount - 1
                map.otherMap.switches[i].image.OffSet(132, 0, 0, 0)
                map.otherMap.switches[i].interactIcon.OffSet(132, 0, 0, 0)
            END FOR
            player.switch = true
        END IF
    END FUNCTION