/*    lda #$0f
    sta WINNER_COLOR
{ // Lives p0
    lda P0CRASHED
    beq nocrash
    ldy P0LIVES
    bne noreset
    lda #1
    sta RESET
    jmp nocrash
noreset:
    dey
    sty P0LIVES
    lda P0COL
    sta WINNER_COLOR
nocrash:
}
{ // Lives p1
    lda P1CRASHED
    beq nocrash
/*    ldy P1LIVES
    bne noreset
    lda #1
    sta RESET
    jmp nocrash
noreset:
    dey
    sty P1LIVES
    lda P1COL
    sta WINNER_COLOR
nocrash:
}*/
