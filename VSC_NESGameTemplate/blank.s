;
; File generated by cc65 v 2.19 - Git b75f872
;
	.fopt		compiler,"cc65 v 2.19 - Git b75f872"
	.setcpu		"6502"
	.smart		on
	.autoimport	on
	.case		on
	.debuginfo	off
	.importzp	sp, sreg, regsave, regbank
	.importzp	tmp1, tmp2, tmp3, tmp4, ptr1, ptr2, ptr3, ptr4
	.macpack	longbranch
	.forceimport	__STARTUP__
	.import		_pal_bg
	.import		_ppu_wait_nmi
	.import		_ppu_on_all
	.import		_set_vram_buffer
	.import		_one_vram_buffer
	.import		_multi_vram_buffer_horz
	.import		_multi_vram_buffer_vert
	.import		_get_ppu_addr
	.export		_palette
	.export		_text
	.export		_LETTERA
	.export		_address
	.export		_main

.segment	"RODATA"

_palette:
	.byte	$0f
	.byte	$00
	.byte	$10
	.byte	$30
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
_text:
	.byte	$48
	.byte	$45
	.byte	$4c
	.byte	$4c
	.byte	$4f
	.byte	$20
	.byte	$57
	.byte	$4f
	.byte	$52
	.byte	$4c
	.byte	$44
	.byte	$21
_LETTERA:
	.byte	$41

.segment	"BSS"

_address:
	.res	2,$00

; ---------------------------------------------------------------
; void __near__ main (void)
; ---------------------------------------------------------------

.segment	"CODE"

.proc	_main: near

.segment	"CODE"

;
; ppu_on_all(); // turn on screen
;
	jsr     _ppu_on_all
;
; pal_bg(palette); // load the palette, this can be done any time, even with rendering on
;
	lda     #<(_palette)
	ldx     #>(_palette)
	jsr     _pal_bg
;
; ppu_wait_nmi(); // wait
;
	jsr     _ppu_wait_nmi
;
; set_vram_buffer(); // points ppu update to vram_buffer, do this at least once
;
	jsr     _set_vram_buffer
;
; one_vram_buffer(LETTERA, NTADR_A(2,3)); // pushes 1 byte worth of data to the vram_buffer
;
	lda     _LETTERA
	jsr     pusha
	ldx     #$20
	lda     #$62
	jsr     _one_vram_buffer
;
; one_vram_buffer(0x42, NTADR_A(5,6)); // another 1 byte write, letter B
;
	lda     #$42
	jsr     pusha
	ldx     #$20
	lda     #$C5
	jsr     _one_vram_buffer
;
; address = get_ppu_addr(0,0x38,0xc0); // (char nt, char x, char y);
;
	jsr     decsp2
	lda     #$00
	ldy     #$01
	sta     (sp),y
	lda     #$38
	dey
	sta     (sp),y
	lda     #$C0
	jsr     _get_ppu_addr
	sta     _address
	stx     _address+1
;
; one_vram_buffer('C', address); // another 1 byte write
;
	lda     #$43
	jsr     pusha
	lda     _address
	ldx     _address+1
	jsr     _one_vram_buffer
;
; multi_vram_buffer_horz(text, sizeof(text), NTADR_A(10,7)); // pushes 12 bytes, horz
;
	jsr     decsp3
	lda     #<(_text)
	ldy     #$01
	sta     (sp),y
	iny
	lda     #>(_text)
	sta     (sp),y
	lda     #$0C
	ldy     #$00
	sta     (sp),y
	ldx     #$20
	lda     #$EA
	jsr     _multi_vram_buffer_horz
;
; multi_vram_buffer_horz(text, sizeof(text), NTADR_A(12,12)); // lower
;
	jsr     decsp3
	lda     #<(_text)
	ldy     #$01
	sta     (sp),y
	iny
	lda     #>(_text)
	sta     (sp),y
	lda     #$0C
	ldy     #$00
	sta     (sp),y
	ldx     #$21
	lda     #$8C
	jsr     _multi_vram_buffer_horz
;
; multi_vram_buffer_horz(text, sizeof(text), NTADR_A(14,17)); // lower still
;
	jsr     decsp3
	lda     #<(_text)
	ldy     #$01
	sta     (sp),y
	iny
	lda     #>(_text)
	sta     (sp),y
	lda     #$0C
	ldy     #$00
	sta     (sp),y
	ldx     #$22
	lda     #$2E
	jsr     _multi_vram_buffer_horz
;
; multi_vram_buffer_vert(text, sizeof(text), NTADR_A(10,7)); // vertical
;
	jsr     decsp3
	lda     #<(_text)
	ldy     #$01
	sta     (sp),y
	iny
	lda     #>(_text)
	sta     (sp),y
	lda     #$0C
	ldy     #$00
	sta     (sp),y
	ldx     #$20
	lda     #$EA
	jsr     _multi_vram_buffer_vert
;
; ppu_wait_nmi(); // waits till nmi, and push new updates to the ppu
;
	jsr     _ppu_wait_nmi
;
; while (1){
;
L0005:	jmp     L0005

.endproc

