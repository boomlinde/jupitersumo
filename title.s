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
    jsr tick_music
:OverscanEnd()
jmp title_loop

tick_music:
    dec MUSIC_TICK
    bne noplay
    jsr play_music
    lda #MUSIC_SPEED
    sta MUSIC_TICK
noplay:
    lda MUSIC_COUNTER
    cmp #6
    beq novol
    lda MUSIC_TICK
    lsr
    sta AUDV0
novol:
    rts
    
play_music:
    ldy MUSIC_COUNTER
    cpy #5
    beq music_off
    cpy #6
    beq music_off
    lda music_freq,y
    sta AUDF0
    lda #1
    sta AUDC0
    lda #$f
    sta AUDV0
    iny
    sty MUSIC_COUNTER
    rts
music_off:
    lda #0
    sta AUDF0
    sta AUDC0
    sta AUDV0
    cpy #6
    beq noenv
    inc MUSIC_COUNTER
noenv:
    rts

music_freq:
//.byte 18, 12, 13, 17
.byte 26,23,19,17,23

