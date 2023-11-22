FUNCTION ColorRGB()
    obj = {
        R: 0.0,
        G: 0.0,
        B: 0.0,
        SetRGBA: FUNCTION(r, g, b)
            m.R = r:
            m.G = g:
            m.B = b:
            RETURN obj:
        END FUNCTION
        SetFromBytes: FUNCTION(bytes):
            m.R = bytes[0] / 255:
            m.G = bytes[1] / 255:
            m.B = bytes[2] / 255:
            RETURN obj:
        END FUNCTION
        Get: FUNCTION():
            c = (m.R * 255 << 24) + (m.G * 255 << 16) + (m.B * 255 << 8) + 255:
            RETURN c:
        END FUNCTION
        Tone: FUNCTION(tone AS float):
            m.R *= tone:
            IF(m.R > 1) THEN
                m.R = 1:
                END IF:
                m.G *= tone:
                IF(m.G > 1) THEN
                    m.G = 1
                    END IF:
                    m.B *= tone:
                    IF(m.B > 1) THEN
                        m.B = 1
                        END IF:
                        RETURN obj:
                    END FUNCTION
                    GetTone: FUNCTION(tone AS float):
                        r = m.R * tone:
                        IF(r > 1) THEN
                            r = 1:
                            END IF:
                            g = m.G * tone:
                            IF(g > 1) THEN
                                g = 1:
                                END IF:
                                b = m.B * tone * tone:
                                IF(b > 1) THEN
                                    b = 1:
                                    END IF:
                                    c = (r * 255 << 24) + (g * 255 << 16) + (b * 255 << 8) + 255:
                                    RETURN c:
                                END FUNCTION
                            }
                            RETURN obj
                        END FUNCTION

                        FUNCTION ColorCode(i)
                            IF i = 0 THEN
                                c = ColorRGB(): c.SetRGBA(1, 0, 0): RETURN c
                            END IF
                            IF i = 1 THEN
                                c = ColorRGB(): c.SetRGBA(1, .5, 0): RETURN c
                            END IF
                            IF i = 2 THEN
                                c = ColorRGB(): c.SetRGBA(1, 1, 0): RETURN c
                            END IF
                            IF i = 3 THEN
                                c = ColorRGB(): c.SetRGBA(.5, 1, 0): RETURN c
                            END IF
                            IF i = 4 THEN
                                c = ColorRGB(): c.SetRGBA(0, 1, 0): RETURN c
                            END IF
                            IF i = 5 THEN
                                c = ColorRGB(): c.SetRGBA(0, 1, .5): RETURN c
                            END IF
                            IF i = 6 THEN
                                c = ColorRGB(): c.SetRGBA(0, 1, 1): RETURN c
                            END IF
                            IF i = 7 THEN
                                c = ColorRGB(): c.SetRGBA(0, .5, 1): RETURN c
                            END IF
                            IF i = 8 THEN
                                c = ColorRGB(): c.SetRGBA(0, 0, 1): RETURN c
                            END IF
                            IF i = 9 THEN
                                c = ColorRGB(): c.SetRGBA(.5, 0, 1): RETURN c
                            END IF
                            IF i = 10 THEN
                                c = ColorRGB(): c.SetRGBA(1, 0, 1): RETURN c
                            END IF
                            IF i = 11 THEN
                                c = ColorRGB(): c.SetRGBA(1, 0, .5): RETURN c
                            END IF
                        END FUNCTION