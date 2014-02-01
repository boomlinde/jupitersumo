
{ // Collision sound
    lda COLLISION_SOUND
    beq nocol
    ldy #8
    sty AUDF1
    ldy #15
    sty AUDC1
    sta AUDV1
    dec COLLISION_SOUND
    jmp sound
nocol:
// Final countdown
    lda FINAL_COUNTDOWN
    beq nosound
    tax
    lsr
    sta AUDV1
    lda #23
    sta AUDF1
    lda #12
    sta AUDC1
    dex
    stx FINAL_COUNTDOWN
    jmp sound
nosound:
    lda #0
    sta AUDC1
    sta AUDV1
sound:
}
