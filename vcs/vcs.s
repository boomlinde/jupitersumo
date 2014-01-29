.var VBLANK_TIMER = VBLANK_LINES*75/64
.var OVERSCAN_TIMER = OVERSCAN_LINES*75/64

.import source "regs.s"

.macro VSync() {
    lda #2
    sta VSYNC
    sta WSYNC
    sta WSYNC
    sta WSYNC
    lda #0
    sta VSYNC
    sta WSYNC
}

.macro VBlankBegin() {
    lda #VBLANK_TIMER
    sta TIM64T
}

.macro VBlankEnd() {
wait:
    lda TIM64T
    bne wait
    sta WSYNC
    lda #0
    sta VBLANK
}

.macro OverscanBegin() {
    sta WSYNC
    lda #2
    sta VBLANK
    lda #OVERSCAN_TIMER
    sta TIM64T
    sta WSYNC
}

.macro OverscanEnd() {
wait:
    lda TIM64T
    bne wait
    sta WSYNC
}

.pc=$f000
init:
    sei
    cld
    ldx #$ff
    txs
    inx
    lda #0
clr:
    sta 0,x
    dex
    bne clr
