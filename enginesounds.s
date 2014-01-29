{
    lda SWCHA
    eor #$ff
    tax
    and #%11000110
    beq noblow
    lda SNDFRAME
    and #1
    bne noblow
    lda #8
    sta AUDC0
    lda #1
    sta AUDF0
    lda #4
    sta AUDV0
    jmp nothrust
noblow:
    txa
    and #$11
    beq nothrust
    lda #8
    sta AUDC0
    lda #20
    sta AUDF0
    lda #8
    sta AUDV0
nothrust:
}
