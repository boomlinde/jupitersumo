.import source "vcs/pal.s"

.pseudocommand nop x {
    .for (var i=0; i<x.getValue(); i++) nop
}

.var MUSIC_SPEED = 16

.var P0COL = $ba
.var P1COL = $6a

.var LINE = $80       // 1 byte
.var PFSTEP = $81     // 1 byte
.var PFSTORE = $82    // 3 bytes
.var P0STORE = $85    // 1 byte
.var P1STORE = $86    // 1 byte
.var M0STORE = $87    // 1 byte
.var M1STORE = $88    // 1 byte
.var P0LIVES = $89    // 1 byte
.var P1LIVES = $8a    // 1 byte
.var P0YCOUNT = $8b     // 1 byte
.var P1YCOUNT = $8c     // 1 byte


//// GAME VARS ////

.var X0_LO = $8d
.var X0_HI = $8e
.var Y0_LO = $8f
.var Y0_HI = $90
.var X1_LO = $91
.var X1_HI = $92
.var Y1_LO = $93
.var Y1_HI = $94

.var SPEEDX0_LO = $95
.var SPEEDX0_HI = $96
.var SPEEDY0_LO = $97
.var SPEEDY0_HI = $98
.var SPEEDX1_LO = $99
.var SPEEDX1_HI = $9a
.var SPEEDY1_LO = $9b
.var SPEEDY1_HI = $9c
.var P0LASTX = $9d
.var P1LASTX = $9e
.var COLLISION_SOUND = $9f

.var BGCOLOR = $a0
.var SNDFRAME = $a1

.var COUNTDOWN = $a2
.var FINAL_COUNTDOWN = $a3
.var EXPLOSION = $a4
.var CRASH = $a5

.var WINNER_COLOR = $a6
.var RESET = $a7
.var JUST_COLLIDED = $a8
.var COLOR = $a9
.var MUSIC_COUNTER = $aa
.var MUSIC_TICK = $ab

///////////////////

    lda #$50
    sta WINNER_COLOR
    lda #1
    sta MUSIC_TICK
.import source "title.s"

jsr game_init

screenloop:
:VSync()
:VBlankBegin()
game_start:
    lda #$5a
    sta COLUPF

    ldx #0
    stx GRP0
    stx GRP1

    lda #$10
    sta PFSTORE
    lda level_pf1
    sta PFSTORE+1
    lda level_pf2
    sta PFSTORE+2

    lda #$ff
    sta PF0
    sta PF1
    sta PF2
    jmp game1
game1_done:
    ldx #0
:VBlankEnd()

prescreen:
    sta WSYNC
    lda P0STORE
    sta GRP0
    lda P1STORE
    sta GRP1
    sta WSYNC
    inx

    // Set player Y postitions
    ldy P0YCOUNT
    lda player,y
    sta P0STORE
    dec P0YCOUNT
    ldy P1YCOUNT
    lda player,y
    sta P1STORE
    dec P1YCOUNT

    cpx #$3
    bne prescreen
    lda PFSTORE
    sta WSYNC
    sta PF0
    jmp screen2
screen:
    sta WSYNC
screen2:
    lda P0STORE
    sta GRP0
    lda P1STORE
    sta GRP1
    lda PFSTORE+1
    sta PF1
    lda PFSTORE+2
    sta PF2

    // Reload player stores

    inx
    txa
    lsr 
    lsr
    tay

    lda #0
    sta WSYNC
    sta VBLANK

    // Load playfield data
    lda level_pf0,y
    sta PFSTORE
    lda level_pf1,y
    sta PFSTORE+1
    lda level_pf2,y
    sta PFSTORE+2

    // Set player Y postitions
    ldy P0YCOUNT
    lda player,y
    sta P0STORE
    dec P0YCOUNT
    ldy P1YCOUNT
    lda player,y
    sta P1STORE
    dec P1YCOUNT

    cpx #PICTURE_LINES/2-9
    bne screen


postscreen:
    sta WSYNC
    lda P0STORE
    sta GRP0
    lda P1STORE
    sta GRP1
    lda #$ff
    sta PF0
    sta PF1
    sta PF2
    sta WSYNC
    inx

    // Set player Y postitions
    ldy P0YCOUNT
    lda player,y
    sta P0STORE
    dec P0YCOUNT
    ldy P1YCOUNT
    lda player,y
    sta P1STORE
    dec P1YCOUNT

    cpx #PICTURE_LINES/2-6
    bne postscreen



    sta WSYNC
    lda #2
    sta VBLANK
    lda #0
    sta GRP0
    sta GRP1
    sta PF0
    sta PF1
    sta PF2
    sta WSYNC
    inx
    sta WSYNC
    sta WSYNC
    lda #0
    sta COLUBK
    sta VBLANK
    inx

// Display lives
scoreview:
    sta WSYNC
    lda #P0COL
    sta COLUPF
    ldy P0LIVES     // 2
    lda livesconv,y // 3
    sta PF1         // 3
    :nop #6
    ldy P1LIVES     // 2
    lda livesconv,y // 3
    sta PF1         // 3
    lda #P1COL
    sta COLUPF
    sta WSYNC
    lda #P0COL
    sta COLUPF
    ldy P0LIVES     // 2
    lda livesconv,y // 3
    sta PF1         // 3
    :nop #6
    ldy P1LIVES     // 2
    lda livesconv,y // 3
    sta PF1         // 3
    lda #P1COL
    sta COLUPF

    inx
    cpx #PICTURE_LINES/2
    bne scoreview

:OverscanBegin()
    jmp game2
game2_done:
:OverscanEnd()

    jmp screenloop

reposp:
    sta WSYNC
    :nop #17
    sta RESP0
    sta WSYNC
    :nop #27
    sta RESP1
    lda #$50
    sta HMP1
    sta WSYNC
    sta HMOVE
    rts

///////////////////////////// GAME CODE ////////////////////////////////////

game1:
.import source "movement.s"
    lda Y0_HI
    sta P0YCOUNT
    lda Y1_HI
    sta P1YCOUNT
    lda BGCOLOR
    sta COLUBK
    jmp game1_done

game2:
    lda SWCHB
    and #1
    bne dontreset
    lda #0
    sta AUDC0
    sta AUDC1
    sta AUDV0
    sta AUDV1
    lda #$50
    sta WINNER_COLOR
    jmp game_end
dontreset:
.import source "crash.s"
    ldx CRASH
    beq nocrash
    stx CXCLR
    lda EXPLOSION
    beq no_explosion
    tay
    lda EXPLOSION
    and #7
    sta AUDF1
    tya
    lsr
    lsr
    sta BGCOLOR
    sta AUDV1
    dey
    sty EXPLOSION
no_explosion:
    dex
    bne norestart

    lda RESET
    beq noreset
    lda #0
    sta RESET
    jmp game_end
noreset:
    jsr game_init
norestart:
    stx CRASH
    jmp game2_done
nocrash:
    lda COUNTDOWN
    beq no_countdown
    tax

    ldy #12
    sty AUDC1
    ldy #31
    sty AUDF1

    and #$1f
    lsr
    lsr
    sta AUDV1

    dex
    dex
    stx COUNTDOWN
    bne nofinal
    lda #20
    sta FINAL_COUNTDOWN
    lda #0-2
    ldy #$48
    sta SPEEDY0_HI
    sta SPEEDY1_HI
    sty SPEEDY0_LO
    sty SPEEDY1_LO
nofinal:
    jmp game2_done
no_countdown:
    // Clear audio
    lda #0
    sta AUDV0
    sta AUDC0

    // Store joystick in x
    lda SWCHA
    eor #$ff

.import source "enginesounds.s"
.import source "input.s"
.import source "sounds.s"

    ldy JUST_COLLIDED
    beq nojc
    dey
    sty JUST_COLLIDED
nojc:
    inc SNDFRAME
    jmp game2_done

game_init:
    lda #0
    sta P0LASTX
    sta P1LASTX
    sta SPEEDX0_HI
    sta SPEEDX0_LO
    sta SPEEDX1_HI
    sta SPEEDX1_LO
    sta SPEEDY0_HI
    sta SPEEDY0_LO
    sta SPEEDY1_HI
    sta SPEEDY1_LO
    sta X0_LO
    sta X0_HI
    sta Y0_LO
    sta Y0_HI
    sta Y0_LO
    sta Y1_LO
    sta COLLISION_SOUND
    sta CRASH
    sta EXPLOSION
    sta BGCOLOR
    sta MUSIC_COUNTER
    sta AUDC0
    sta AUDF0
    sta AUDV0
    lda #1
    sta MUSIC_TICK
    lda #96
    sta Y0_HI
    sta Y1_HI
    lda #5
    sta CTRLPF
    lda #P0COL
    sta COLUP0
    lda #P1COL
    sta COLUP1
    jsr reposp
    lda #$60
    sta COUNTDOWN
    rts

livesconv:
    .byte 0
    .byte %00000010
    .byte %00001010
    .byte %00101010
    .byte %10101010

.import source "level.s"
.import source "player.s"
.import source "title_left.s"
.import source "title_right.s"
lander_pf2: .byte 0,0,0,0,192,224,240,48,240,240,32,112

.import source "vcs/vectors.s"
