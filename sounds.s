
{ // Collision sound
    lda COLLISION_SOUND
    beq nocol
    ldy #8
    sty AUDF1
    ldy #15
    sty AUDC1
    sta AUDV1
    dec COLLISION_SOUND
    jmp col
nocol:
    lda #0
    sta AUDC1
    sta AUDV1
col:
}
