{
    lda CRASH
    bne nocrash
    lda CXP0FB
    ora CXP1FB
    and #$80
    beq nocrash
    lda #8
    sta AUDC1
    lda #0
    sta AUDV0
    sta AUDC0
    lda #$80
    sta CRASH
    lda #$3f
    sta EXPLOSION
    lda #0
    sta SPEEDY0_LO
    sta SPEEDY0_HI
    sta SPEEDY1_LO
    sta SPEEDY1_HI
    sta SPEEDX0_LO
    sta SPEEDX0_HI
    sta SPEEDX1_LO
    sta SPEEDX1_HI

    lda CXP0FB
    and #$80
    beq nocrashp0
    dec P0LIVES
nowinnerp0:
    lda #120
    sta Y0_HI
    lda P0LIVES
    bne nocrashp0
    lda #1
    sta RESET
nocrashp0:
    lda CXP1FB
    and #$80
    beq nocrashp1
    dec P1LIVES
nowinnerp1:
    lda #120
    sta Y1_HI
    lda P1LIVES
    bne nocrashp1
    lda #1
    sta RESET
nocrashp1:
    lda P0LIVES
    ora P1LIVES
    bne notboth
    lda #$50
    sta WINNER_COLOR
    jmp nocrash
notboth:
    lda P0LIVES
    bne checknext
    lda #P1COL-10
    sta WINNER_COLOR
    jmp nocrash
checknext:
    lda P1LIVES
    bne nocrash
    lda #P0COL-10
    sta WINNER_COLOR
nocrash:
}
