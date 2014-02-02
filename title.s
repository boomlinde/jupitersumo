title_loop:
title: {
:VSync()
:VBlankBegin()
    lda #4
    sta P0LIVES
    sta P1LIVES
    ldx #0
    ldy #0

    lda INPT4
    and INPT5
    and #$80
    bne noplay
    jsr game_init
    jmp game_start
noplay:
    sty PF0
    sty PF1
    sty PF2
    lda #5
    sta CTRLPF
:VBlankEnd()

lander:
    sta WSYNC
    lda lander_pf2,y
    sta PF2
    inx
    txa
    lsr
    lsr
    lsr
    tay
    cpx #96
    bne lander
    ldx #0

break:
    sta WSYNC
    lda #0
    sta CTRLPF
    sta PF0
    sta PF1
    sta PF2
    inx
    cpx #24
    bne break
    ldx #0
    ldy #0

title:
    sta WSYNC
    txa
    and #$f
    ora #$50
    sta  COLUPF
    lda #0
    sta PF0
    lda title_left_pf1,y
    sta PF1
    lda title_left_pf2,y
    sta PF2
    nop nop
    lda title_right_pf0,y
    sta PF0
    lda title_right_pf1,y
    sta PF1
    lda title_right_pf2,y
    sta PF2
    inx
    txa
    lsr
    lsr
    lsr
    tay
    cpx #80
    bne title

final:
    sta WSYNC
    lda #0
    sta PF0
    sta PF1
    sta PF2
    inx
    cpx #PICTURE_LINES-96-24
    bne final
}
:OverscanBegin()
game_end:
    inc COLOR
    lda COLOR
    and #$f
    ora WINNER_COLOR
    sta COLUPF
:OverscanEnd()
jmp title_loop
