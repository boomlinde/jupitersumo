.var LSPEED = 11
.var RSPEED = 0-11
.var VSPEED = 0-21
.var GRAVITY = 10

    lda CXPPMM
    and #$80
    beq input_nocol

    ldy JUST_COLLIDED
    bne input_nocol

    // Collision energy transfer
    lda SPEEDX0_LO
    ldy SPEEDX1_LO
    sta SPEEDX1_LO
    sty SPEEDX0_LO
    lda SPEEDY0_LO
    ldy SPEEDY1_LO
    sta SPEEDY1_LO
    sty SPEEDY0_LO
    
    lda SPEEDX0_HI
    ldy SPEEDX1_HI
    sta SPEEDX1_HI
    sty SPEEDX0_HI
    lda SPEEDY0_HI
    ldy SPEEDY1_HI
    sta SPEEDY1_HI
    sty SPEEDY0_HI
    lda #$f
    sta COLLISION_SOUND

    lda #4
    sta JUST_COLLIDED

    jmp input_nocheck
input_nocol:
{ // player 0
    txa
    and #$10 // Up button
    beq noup
    clc
    lda SPEEDY0_LO
    adc #<VSPEED
    sta SPEEDY0_LO
    lda SPEEDY0_HI
    adc #>VSPEED
    sta SPEEDY0_HI
noup:

    txa
    and #$80 // Right button
    beq nor
    clc
    lda SPEEDX0_LO
    adc #<RSPEED
    sta SPEEDX0_LO
    lda SPEEDX0_HI
    sta P0LASTX
    adc #>RSPEED
    sta SPEEDX0_HI
    jmp nohor

nor:
    txa
    and #$40 // Left button
    beq nohor
    clc
    lda SPEEDX0_LO
    adc #<LSPEED
    sta SPEEDX0_LO
    lda SPEEDX0_HI
    sta P0LASTX
    adc #>LSPEED
    sta SPEEDX0_HI
nohor:
}

{ // player 1
    txa
    and #1 // Up button
    beq noup
    clc
    lda SPEEDY1_LO
    adc #<VSPEED
    sta SPEEDY1_LO
    lda SPEEDY1_HI
    adc #>VSPEED
    sta SPEEDY1_HI
noup:

    txa
    and #8 // Right button
    beq nor
    clc
    lda SPEEDX1_LO
    adc #<RSPEED
    sta SPEEDX1_LO
    lda SPEEDX1_HI
    sta P1LASTX
    adc #>RSPEED
    sta SPEEDX1_HI
    jmp nohor

nor:
    txa
    and #4 // Left button
    beq nohor
    clc
    lda SPEEDX1_LO
    adc #<LSPEED
    sta SPEEDX1_LO
    lda SPEEDX1_HI
    sta P1LASTX
    adc #>LSPEED
    sta SPEEDX1_HI
nohor:
}

input_nocheck:
    sta CXCLR

{ // Gravity p0
    clc
    lda SPEEDY0_LO
    adc #<GRAVITY
    sta SPEEDY0_LO
    lda SPEEDY0_HI
    adc #>GRAVITY
    sta SPEEDY0_HI
}

{ // Gravity p1
    clc
    lda SPEEDY1_LO
    adc #<GRAVITY
    sta SPEEDY1_LO
    lda SPEEDY1_HI
    adc #>GRAVITY
    sta SPEEDY1_HI
}

