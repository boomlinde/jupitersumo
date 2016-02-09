    clc
    lda Y0_LO
    adc SPEEDY0_LO
    sta Y0_LO
    lda Y0_HI
    adc SPEEDY0_HI
    sta Y0_HI

    clc
    lda X0_LO
    adc SPEEDX0_LO
    sta X0_LO
    lda X0_HI
    sta P0LASTX
    adc SPEEDX0_HI
    sta X0_HI

    sec
    sbc P0LASTX
    asl
    asl
    asl
    asl
    clc
    sta HMP0

    clc
    lda Y1_LO
    adc SPEEDY1_LO
    sta Y1_LO
    lda Y1_HI
    adc SPEEDY1_HI
    sta Y1_HI

    clc
    lda X1_LO
    adc SPEEDX1_LO
    sta X1_LO
    lda X1_HI
    sta P1LASTX
    adc SPEEDX1_HI
    sta X1_HI

    sec
    sbc P1LASTX
    asl
    asl
    asl
    asl
    clc
    sta HMP1

    sta WSYNC
    sta HMOVE
