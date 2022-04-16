����                                        ;--------------------------------------------------------;
;  -=:) Mysterious Chips was coded by Zacco/Mystic (:=-  ;
;--------------------------------------------------------;
posnr	=	16
lines	=	36

xyadd	=	24		; 24
xzadd	=	24		; 18
yzadd	=	24		; 18

mittx	=	90
mitty	=	108
mittz	=	900

zoom	=	4000
BYTEWIDTH = 	40
;--------------------------------------------------------;
        section Proggy,code_c
;--------------------------------------------------------;
bltw    macro
blt\@   btst    #$e,$dff002
        bne.s   blt\@
        endm
sync	macro
sy\@	cmp.b	#\1,$dff006
	bne.s	sy\@
	endm
;--------------------------------------------------------;
Init	move.l	$4,a6
	lea.l	gfxn(pc),a1
	jsr	-408(a6)
	move.l	d0,a1
	lea.l	oldcop,a0
	move.l	$26(a1),(a0)
	jsr	-414(a6)
;--------------------------------------------------------;
InitStuff
        lea     scr,a0
        lea     bpl,a1
        move.l  a0,d0
	move.w  d0,6(a1)
        swap    d0
        move.w  d0,2(a1)
	add.w	#8,a1
        lea     scr2,a0
        move.l  a0,d0
	move.w  d0,6(a1)
        swap    d0
        move.w  d0,2(a1)

	lea.l	scr_A,a0
	move.l	a0,d0
	lea.l	bpl_a,a1
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)

	lea.l	scr_b,a0
	lea.l	bpl_b,a1
	move.l	a0,d0
	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)

	lea.l	mstscr,a0
	lea.l	mstbpl,a1
	move.l	a0,d0
	move.w	#3,d7
logolop	move.w	d0,6(a1)
	swap	d0
	move.w	d0,2(a1)
	swap	d0
	add.l	#1720,d0
	add.w	#8,a1
	dbf	d7,logolop
;--------------------------------------------------------;
	lea.l	mod1_b,a0
	jsr	mt_init_b
;--------------------------------------------------------;
	lea.l	$dff000,a6
	move.w	$2(a6),olddma
	or.w	#$8200,olddma
	move.w	$1c(a6),oldint
	or.w	#$8000,oldint
	move.w	#$7fff,$9a(a6)
	move.w	#$7fff,$96(a6)
	move.l	#clist,$80(a6)
	move.w	#$4000,$9a(a6)
	move.w	#$83c0,$96(a6)
;--------------------------------------------------------;
	lea.l	menybak,a0
	move.l	a0,d0
	lea.l	scr_b,a1
	move.l	a1,d1
	add.l	#24,d1
	lea.l	$dff000,a6
	bltw
	move.l	#$09f00000,$40(a6)
	move.l	#-1,$44(a6)
	move.l	d0,$50(a6)
	move.l	d1,$54(a6)
	move.w	#0,$64(a6)
	move.w	#24,$66(a6)
	move.w	#64*256+8,$58(a6)

	lea.l	mystlog,a0
	move.l	a0,d0
	lea.l	mstscr,a1
	move.l	a1,d1
	lea.l	$dff000,a6
	move.w	#3,d7
bltmst	bltw
	move.l	#$09f00000,$40(a6)
	move.l	#-1,$44(a6)
	move.l	d0,$50(a6)
	move.l	d1,$54(a6)
	move.w	#0,$64(a6)
	move.w	#0,$66(a6)
	move.w	#64*43+20,$58(a6)
	add.l	#1720,d0
	add.l	#1720,d1
	dbf	d7,bltmst
;--------------------------------------------------------;
	move.w	#tlen_b-2,d6
typelop_b	bsr	type_b
	dbf	d6,typelop_b

	move.w	#0,filled_b
	move.w	#1,d5
	lea.l	scr2,a5
ramlop	bsr	initline_b
	move.w	xp11_b,d0
	move.w	yp11_b,d1
	move.w	xp22_b,d2
	move.w	yp11_b,d3
	bsr	dline_b
	move.w	#$c5,yp22_b
	move.w	xp11_b,d0
	move.w	yp11_b,d1
	move.w	xp11_b,d2
	move.w	yp22_b,d3
	bsr	dline_b
	move.w	xp22_b,d0
	move.w	yp11_b,d1
	move.w	xp22_b,d2
	move.w	yp22_b,d3
	bsr	dline_b
	move.w	xp11_b,d0
	move.w	yp22_b,d1
	move.w	xp22_b,d2
	move.w	yp22_b,d3
	bsr	dline_b
	lea.l	scr_b,a5
	dbf	d5,ramlop
	move.w	#2,filled_b

	move.w	#tlen_A,tleng_A
	move.w	#tlen2_A,tleng2_A
	move.w	#tlen2_Ab,tleng2_Ab
	move.l	#text_A,txtptr_A
;--------------------------------------------------------;
mbeg	sync	$ff

	cmp.w	#$f,fadez
	beq.s	MainL
	lea.l	scrcols,a0
	lea.l	tocols,a1
	lea.l	addtabwholescr,a2
	add.w	#2,a0
	move.w	#cols-1,d7
	bsr	fade
	add.w	#1,fadez

	bra.s	mbeg
;--------------------------------------------------------;
MainL	sync	$ff

	bsr	clear
	bsr	clear2
	bsr	rotate
	bsr	perspective
	bsr	drawvec
	bsr	fill
	bsr	fill2

	bsr	mousetst_b
	bsr	typping_A

	jsr	mt_music_b

	btst	#2,$dff016
	beq.w	End

mouse_b	btst	#6,$bfe001
	bne.w	MainL

	cmp.b	#$30,balkb_b
	bne.s	tst2_b
	lea.l	mod1_b,a0
	jsr	mt_init_b
	bra.w	MainL
tst2_b	cmp.b	#$40,balkb_b
	bne.w	tst3_b
	lea.l	mod2_b,a0
	jsr	mt_init_b
	bra.w	MainL
tst3_b	cmp.b	#$50,balkb_b
	bne.w	tst4
	lea.l	mod3_b,a0
	jsr	mt_init_b
	bra.w	MainL
tst4	cmp.b	#$60,balkb_b
	bne.w	tst5
	lea.l	mod4,a0
	jsr	mt_init_b
	bra.w	MainL
tst5	cmp.b	#$70,balkb_b
	bne.w	tst6
	lea.l	mod5,a0
	jsr	mt_init_b
	bra.w	MainL
tst6	cmp.b	#$80,balkb_b
	bne.w	tst7
	lea.l	mod6,a0
	jsr	mt_init_b
	bra.w	MainL
tst7	cmp.b	#$90,balkb_b
	bne.w	tst8
	lea.l	mod7,a0
	jsr	mt_init_b
	bra.w	MainL
tst8	cmp.b	#$a0,balkb_b
	bne.w	tst9
	lea.l	mod8,a0
	jsr	mt_init_b
	bra.w	MainL
tst9	cmp.b	#$b0,balkb_b
	bne.w	tst10
	lea.l	mod9,a0
	jsr	mt_init_b
	bra.w	MainL
tst10	cmp.b	#$c0,balkb_b
	bne.w	tst11
	lea.l	mod10,a0
	jsr	mt_init_b
	bra.w	MainL
tst11	cmp.b	#$d0,balkb_b
	bne.w	tst12
	lea.l	mod11,a0
	jsr	mt_init_b
	bra.w	MainL
tst12	cmp.b	#$e0,balkb_b
	bne.w	MainL
	lea.l	mod12,a0
	jsr	mt_init_b
	bra.w	MainL
;--------------------------------------------------------;
End	jsr	mt_end_b
	lea.l	$dff000,a6
        move.w  #$7fff,$9a(a6)
        move.w  #$7fff,$96(a6)
	move.l	oldcop,$80(a6)
	move.w	oldint,$9a(a6)
	move.w	olddma,$96(a6)
	rts
;--------------------------------------------------------;
clear	lea.l	scr,a0
	move.l	a0,d0
	add.l	#35*40+2,d0
	lea.l	$dff000,a6
	bltw
	move.l	#$01000000,$40(a6)
	move.l	d0,$54(a6)
	move.w	#22,$66(a6)
	move.w	#64*135+9,$58(a6)
	rts
;--------------------------------------------------------;
clear2	lea.l	scr2,a0
	move.l	a0,d0
	add.l	#35*40+2,d0
	lea.l	$dff000,a6
	bltw
	move.l	#$01000000,$40(a6)
	move.l	d0,$54(a6)
	move.w	#22,$66(a6)
	move.w	#64*135+9,$58(a6)
	rts
;--------------------------------------------------------;
; Formler for att rotera
;
; x1 = cos*xc - sin*yc
; y1 = sin*xc + cos*yc
;
; x2 = cos*x1 - sin*zc
; z1 = sin*x1 + cos*zc
;
; y2 = cos*y1 - sin*z1
; z2 = sin*y1 + cos*z1
;
rotate	lea.l	sin(pc),a0
	lea.l	cos(pc),a1
	lea.l	xcoords(pc),a2
	lea.l	ycoords(pc),a3
	lea.l	xn(pc),a4
	lea.l	yn(pc),a5
	lea.l	xybla(pc),a6
	move.w	#xyadd,d5
	move.w	#posnr-1,d7
	bsr	rot
	lea.l	zcoords(pc),a2
	lea.l	xn(pc),a3
	lea.l	zn(pc),a4
	lea.l	xn(pc),a5
	lea.l	xzbla(pc),a6
	move.w	#xzadd,d5
	move.w	#posnr-1,d7
	bsr	rot
	lea.l	yn(pc),a2
	lea.l	zn(pc),a3
	lea.l	yn(pc),a4
	lea.l	zn(pc),a5
	lea.l	yzbla(pc),a6
	move.w	#yzadd,d5
	move.w	#posnr-1,d7
	bsr	rot
	rts
rot	add.w	d5,(a6)
	move.w	(a6),d5
	and.w	#4095,d5
	move.w	(a0,d5.w),d0
	move.w	(a1,d5.w),d1
rotat	move.w	d0,d2
	move.w	d1,d3
	move.w	d2,d4
	move.w	d3,d5
	muls	(a2),d3
	muls	(a3),d2
	asr.l	#8,d3
	asr.l	#8,d2
	sub.w	d2,d3
	muls	(a2)+,d4
	muls	(a3)+,d5
	asr.l	#8,d4
	asr.l	#8,d5
	add.w	d4,d5
	move.w	d3,(a4)+
	move.w	d5,(a5)+
	dbf	d7,rotat
	rts
;--------------------------------------------------------;
; Formler for perspektiv
;
; x = (xc*(zc+origoz)/zoom)+origox
; y = (yc*(zc+origoz)/zoom)+origoy
;
perspective
	lea.l	xn(pc),a0
	lea.l	yn(pc),a1
	lea.l	zn(pc),a2
	lea.l	nxcoord(pc),a3
	lea.l	nycoord(pc),a4
	move.w	#posnr-1,d7
persp	move.w	(a0)+,d0
	move.w	(a1)+,d1

	move.w	(a2),d2
	add.w	#mittz,d2
	muls	d2,d0
	divs	#zoom,d0
	add.w	#mittx,d0
	move.w	d0,(a3)+

	move.w	(a2)+,d2
	add.w	#mittz,d2
	muls	d2,d1
	divs	#zoom,d1
	add.w	#mitty,d1
	move.w	d1,(a4)+
	dbf	d7,persp
	rts
;--------------------------------------------------------;
drawvec	bsr	initline
	lea.l	nxcoord(pc),a0
	lea.l	nycoord(pc),a1
	lea.l	drawtab(pc),a2
	lea.l	coltab(pc),a3
	move.w	#8,d7
draw	move.b	(a3)+,d0
	cmp.b	#0,d0
	bne.s	nxtc
	lea.l	scr,a5
	move.w	#3,d6
	bsr	dv
	bra.w	dd
nxtc	lea.l	scr2,a5
	move.w	#3,d6
	bsr	dv
dd	dbf	d7,draw
	rts
dv	move.w	(a2)+,d1
	move.w	(a0,d1.w),d0
	move.w	(a1,d1.w),d1
	move.w	(a2)+,d3
	move.w	(a0,d3.w),d2
	move.w	(a1,d3.w),d3
	bsr	dline
	dbf	d6,dv
	rts
;--------------------------------------------------------;
initline:
	lea.l	$dff000,a6
bltw2:	btst	#14,$002(a6)
	bne	bltw2
	move.l	#$ffff8000,$72(a6)
	move.l	#$ffffffff,$44(a6)
	move.w	#40,$60(a6)	
	rts
;--------------------------------------------------------;---
dline:	lea.l	$dff000,a6
	moveq	#40,d5
	cmp.w	d1,d3
	bgt	line1
	exg	d0,d2
	exg	d1,d3
	beq	out
line1:	move.w	d1,d4
	muls	d5,d4
	move.w	d0,d5
	add.l	a5,d4
	asr.w	#3,d5
	add.w	d5,d4
	moveq	#0,d5
	sub.w	d1,d3
	sub.w	d0,d2
	bpl	line2
	moveq	#1,d5
	neg.w	d2
line2:	move.w	d3,d1
	add.w	d1,d1
	cmp.w	d2,d1
	dbhi	d3,line3
line3:	move.w	d3,d1
	sub.w	d2,d1
	bpl	line4
	exg	d2,d3
line4:	addx.w	d5,d5
	add.w	d2,d2
	move.w	d2,d1
	sub.w	d3,d2
	addx.w	d5,d5
	and.w	#15,d0
	ror.w	#4,d0
	or.w	#$a4a,d0
wblt3:	btst	#6,2(a6)
	bne	wblt3
	move.w	d2,$52(a6)
	sub.w	d3,d2
	lsl.w	#6,d3
	addq.b	#2,d3
	move.w	d0,$40(a6)
	move.b	oct(pc,d5.w),$43(a6)
	move.l	d4,$48(a6)
	move.l	d4,$54(a6)
	movem.w	d1/d2,$62(a6)
	move.w	d3,$58(a6)
out:	rts
oct:	dc.b	$3,$43,$13,$53,$b,$4b,$17,$57
;--------------------------------------------------------;
fill	lea.l	scr,a0
	move.l	a0,d0
	add.l	#165*40+18,d0
	lea.l	$dff000,a6
	bltw
	move.l	#$09f00012,$40(a6)
	move.l	#-1,$44(a6)
	move.l	d0,$50(a6)
	move.l	d0,$54(a6)
	move.w	#22,$64(a6)
	move.w	#22,$66(a6)
	move.w	#64*130+9,$58(a6)
	rts
;--------------------------------------------------------;
fill2	lea.l	scr2,a0
	move.l	a0,d0
	add.l	#165*40+18,d0
	lea.l	$dff000,a6
	bltw
	move.l	#$09f00012,$40(a6)
	move.l	#-1,$44(a6)
	move.l	d0,$50(a6)
	move.l	d0,$54(a6)
	move.w	#22,$64(a6)
	move.w	#22,$66(a6)
	move.w	#64*130+9,$58(a6)
	rts
;--------------------------------------------------------;
type_A	moveq	#0,d0
	moveq	#0,d1
	moveq	#0,d2
	lea.l	xptab_A(pc),a3
	lea.l	yptab_A(pc),a4
	move.w	tabpos_A,d2
	move.w	(a3,d2.w),d1
	move.w	(a4,d2.w),d2
	cmp.w	#-1,d1
	beq.s	subtxt_A
satan_A	add.l	d1,txtptr_A
	bra.s	helvete_A
subtxt_A
	sub.l	#1,txtptr_A
helvete_A
	cmp.w	#-1,d2	
	beq.s	hmmm_A
	muls	#24,d2
	add.l	d2,txtptr_A
	bra.s	tfuck_A
hmmm_A	sub.l	#24,txtptr_A
tfuck_A	move.l	txtptr_A,a0
	move.b	(a0),d0
	cmp.b	#1,d0
	beq.w	tend_A
	sub.b	#32,d0
	add.l	#font_A,d0
	move.l	d0,a0
	moveq	#0,d1
	lea.l	letxpos_A(pc),a1
	lea.l	letypos_A(pc),a2
	lea.l	xptab_A(pc),a3
	lea.l	yptab_A(pc),a4
	move.w	tabpos_A,d2
	add.w	#2,tabpos_A
	move.w	(a3,d2.w),d3
	move.w	(a4,d2.w),d4
	move.w	d4,d5
	cmp.w	#0,d4
	beq.s	xxx_A
	add.w	#8,d4
	muls	#40,d4
	cmp.w	#-1,d5
	bne.s	yyy_A
	add.w	#2*40,d4
	sub.w	d4,(a2)
	bra.s	xxx_A
yyy_A	add.w	d4,(a2)
xxx_A	add.w	d3,(a1)
	move.w	(a2),d1
	add.w	(a1),d1
	add.l	#scr_A,d1
	move.l	d1,a1
	move.w	#7,d7
letlop_A	move.b	(a0),(a1)
	add.w	#96,a0
	add.w	#40,a1
	dbf	d7,letlop_A
tend_A	rts
;--------------------------------------------------------;
typping_A	cmp.w	#0,tleng_A
	beq.s	nxtt_A
	bsr	type_A
	sub.w	#1,tleng_A
	bra.w	blaaa_A

nxtt_A	cmp.w	#1000,txtwtime
	beq.s	clrfscr
	add.w	#1,txtwtime
	bra.w	blaaa_A

clrfscr	cmp.b	#1,cleared
	beq.s	nxtat_a
	lea.l	scr_A,a0
	move.l	a0,d0
	lea.l	$dff000,a6
	bltw
	move.l	#$01000000,$40(a6)
	move.l	d0,$54(a6)
	move.w	#16,$66(a6)
	move.w	#64*190+12,$58(a6)
	move.b	#1,cleared

nxtat_a	cmp.w	#1,nxttxt_A
	beq.s	nxttt_A
	move.l	#text2_A,txtptr_A
	move.w	#1,nxttxt_A
	clr.w	tabpos_A
	clr.w	letxpos_A
	move.w	#1*[8*40]+[4*40],letypos_A
	bra.w	blaaa_A

nxttt_A	cmp.w	#0,tleng2_A
	beq.s	nxtt_Ab
	bsr	type_A
	sub.w	#1,tleng2_A
	bra.w	blaaa_A

nxtt_Ab	cmp.w	#1000,txtwtimeb
	beq.s	clrfscrb
	add.w	#1,txtwtimeb
	bra.w	blaaa_A

clrfscrb
	cmp.b	#1,clearedb
	beq.s	nxtat_ab
	lea.l	scr_A,a0
	move.l	a0,d0
	lea.l	$dff000,a6
	bltw
	move.l	#$01000000,$40(a6)
	move.l	d0,$54(a6)
	move.w	#16,$66(a6)
	move.w	#64*190+12,$58(a6)
	move.b	#1,clearedb

nxtat_ab
	cmp.w	#1,nxttxt_Ab
	beq.s	nxttt_Ab
	move.l	#text2_Ab,txtptr_A
	move.w	#1,nxttxt_Ab
	clr.w	tabpos_A
	clr.w	letxpos_A
	move.w	#1*[8*40]+[4*40],letypos_A
	bra.s	blaaa_A

nxttt_Ab
	cmp.w	#0,tleng2_Ab
	beq.s	blaaa_A
	bsr	type_A
	sub.w	#1,tleng2_Ab

blaaa_A	rts
;--------------------------------------------------------;
mousetst_b
	moveq   #0,d0
	move.b  $dff00a,d0
	and.w   #~15,d0
	move.b  d0,balkb_b
	add.w	#16,d0
	move.b	d0,balks_b
	cmp.b   #$30,balkb_b
        bhi     munxt_b
	move.b	#$30,balkb_b
	move.b	#$40,balks_b
munxt_b	cmp.b	#$e0,balkb_b
	blo	mend_b
	move.b	#$e0,balkb_b
	move.b	#$f0,balks_b
mend_b	rts
;--------------------------------------------------------;
type_b	moveq	#0,d0
	move.l	txtptr_b,a0
	move.b	(a0),d0
	bne.s	tcont_b
	move.l	#text_b,txtptr_b
	bra.s	type_b
tcont_b	cmp.b	#1,d0
	beq.s	nxtline_b
	cmp.b	#2,d0
	beq.s	tend_b
	addq.l	#1,txtptr_b
	sub.b	#32,d0
	add.l	#font_A,d0
	move.l	d0,a0
	moveq	#0,d1
	lea.l	letpos_b(pc),a1
	move.w	(a1),d1
	addq.w	#1,(a1)
	add.l	#scr_A,d1
	move.l	d1,a1
	move.w	#7,d7
letlop_b
	move.b	(a0),(a1)
	add.w	#96,a0
	add.w	#40,a1
	dbf	d7,letlop_b
	bra.s	tend_b
nxtline_b
	add.w	#16*40,letpos_b
	sub.w	#13,letpos_b
	addq.l	#1,txtptr_b
tend_b	rts
;--------------------------------------------------------;
initline_b
	lea.l	$dff000,a6
	bltw
	move.l	#-1,$44(a6)
	move.l	#-$8000,$72(a6)
	move.w	#40,$60(a6)
	rts
;--------------------------------------------------------;
dline_b:	lea.l	$dff000,a6
	sub.w	d3,d1
;	beq.w	noline		
	mulu	#40,d3
	moveq	#$f,d4
	and.w	d2,d4
	sub.w	d2,d0
	blt.s	draw_dont0146
	tst.w	d1
	blt.s	draw_dont04
	cmp.w	d0,d1
	bge.s	draw_select0
	moveq	#$11,d6
	bra.s	draw_octselected
draw_select0:
	moveq	#1,d6
	exg	d0,d1
	bra.s	draw_octselected
draw_dont04:
	neg.w	d1
	cmp.w	d0,d1
	bge.s	draw_select1
	moveq	#$19,d6
	bra.s	draw_octselected
draw_select1:
	moveq	#5,d6
	exg	d0,d1
	bra.s	draw_octselected
draw_dont0146:
	neg.w	d0
	tst.w	d1
	blt.s	draw_dont25
	cmp.w	d0,d1
	bge.s	draw_select2
	moveq	#$15,d6
	bra.s	draw_octselected
draw_select2:
	moveq	#9,d6
	exg	d0,d1
	bra.s	draw_octselected
draw_dont25:
	neg.w	d1
	cmp.w	d0,d1
	bge.s	draw_select3
	moveq	#$1d,d6
	bra.s	draw_octselected
draw_select3:
	moveq	#$d,d6
	exg	d0,d1
draw_octselected:
	add.w	filled,d6
	add.w	d1,d1
	asr.w	#3,d2
	ext.l	d2
	add.l	d2,d3
	move.w	d1,d2
	sub.w	d0,d2
	bge.s	draw_dontsetsign
	ori.w	#$40,d6
draw_dontsetsign:
	bltw
	move.w	d2,$52(a6)
	move.w	d1,$62(a6)
	sub.w	d0,d2
	move.w	d2,$64(a6)
	asl.w	#6,d0
	add.w	#$0042,d0
	ror.w	#4,d4
	ori.w	#$bea,d4	;$b4a=or / $bea=eor
	swap	d6
	move.w	d4,d6
	swap	d6
	add.l	a5,d3
	move.l	d6,$40(a6)
	move.l	d3,$48(a6)
	move.l	d3,$54(a6)
	move.w	d0,$58(a6)
	rts
;--------------------------------------------------------;
fade	move.w	(a0),d0
	move.w	(a1),d1
	and.w	#$f00,d0
	and.w	#$f00,d1
	cmp.w	d0,d1
	beq.s	fb
	bcs.s	fsub
	add.w	#$200,(a0)
fsub	sub.w	#$100,(a0)
fb	move.w	(a0),d0
	move.w	(a1),d1
	and.w	#$f0,d0
	and.w	#$f0,d1
	cmp.w	d0,d1
	beq.s	fc
	bcs.s	fsub2
	add.w	#$20,(a0)
fsub2	sub.w	#$10,(a0)
fc	move.w	(a0),d0
	move.w	(a1),d1
	and.w	#$f,d0
	and.w	#$f,d1
	cmp.w	d0,d1
	beq.s	fend
	bcs.s	fsub3
	add.w	#$2,(a0)
fsub3	sub.w	#$1,(a0)
fend	add.w	(a2)+,a0
	add.w	#2,a1
	dbf	d7,fade
	rts
;--------------------------------------------------------;
	incdir	dh1:
	include	'replay_a0.S'
;--------------------------------------------------------;
gfxn		dc.b	'graphics.library',0,0
oldcop		dc.l	0
olddma		dc.w	0
oldint		dc.w	0
xcoords		dc.w	-150,-50,50,150
		dc.w	-150,-50,50,150
		dc.w	-150,-50,50,150
		dc.w	-150,-50,50,150
ycoords		dc.w	-150,-150,-150,-150
		dc.w	-50,-50,-50,-50
		dc.w	50,50,50,50
		dc.w	150,150,150,150
zcoords		dc.w	   0,   0,   0,   0
		dc.w	0,0,0,0,0,0,0,0,0,0,0,0

drawtab		dc.w	00,02,02,10,10,08,08,00
		dc.w	02,04,04,12,12,10,10,02
		dc.w	04,06,06,14,14,12,12,04
		dc.w	08,10,10,18,18,16,16,08
		dc.w	10,12,12,20,20,18,18,10
		dc.w	12,14,14,22,22,20,20,12
		dc.w	16,18,18,26,26,24,24,16
		dc.w	18,20,20,28,28,26,26,18
		dc.w	20,22,22,30,30,28,28,20

xn		blk.w	posnr
yn		blk.w	posnr
zn		blk.w	posnr
nxcoord		blk.w	posnr
nycoord		blk.w	posnr
xybla		dc.w	0
xzbla		dc.w	0
yzbla		dc.w	0
filled		dc.w	0
coltab		dc.b	0,1,0,1,0,1,0,1,0
	even
txtptr_A	dc.l	0
letxpos_A	dc.w	0
letypos_A	dc.w	1*[8*40]+[4*40]
text_A		dc.b	'       - MyStIc -       '
		dc.b	'                        '
		dc.b	'     ...PrEsEnTs...     '
		dc.b	'                        '
		dc.b	'  -=Mysterious Chips=-  '
		dc.b	'           I            '
		dc.b	'                        '
		dc.b	'   -=:) CrEdiTz (:=-    '
		dc.b	'------------------------'
		dc.b	'Coding By :        Zacco'
		dc.b	'Dezign By :        Zacco'
		dc.b	'All Music By : Hellhound'
		dc.b	'Gfx By :       Slime/IFT'
		dc.b	'------------------------'
		dc.b	'                        '
		dc.b	'   This is the first    '
		dc.b	'  -ChipMod Pack- from   '
		dc.b	'     -= Mystic =-       '
		dc.b	'  Released: 1993-08-22  '
		dc.b	'  Listen and enjoy...   '
tlen_A		equ	*-text_A
tleng_A		dc.w	0

text2_A;	dc.b	'------------------------'
		dc.b	'HoaAAhh! HEllH0unD here!'
		dc.b	'Well, the MuSiC isnt of '
		dc.b	'a vEry High QuAlity..ehe'
		dc.b	'So bEwarE oF tHat! hihi!'
		dc.b	'So.. sUm pErsOnal greets'
		dc.b	'flieS Out 2.............'
		dc.b	'Benny Da Bajsmann/Eureca'
		dc.b	'CatEAR/Taurus           '
		dc.b	'DeseTRactor/X-Trade     '
		dc.b	'Airbrain/MST -SNES RULZ!'
		dc.b	'Axe/MST - The board is  '
		dc.b	'OFFline now.. happy now?'
		dc.b	'Borre/MST -Ill give ya  '
		dc.b	'a PlingeLing soon!      '
		dc.b	'Aron/MSt - SATAN!!!     '
		dc.b	'And 2 all other in MST..'
		dc.b	'A mezz 2 everybody:     '
		dc.b	'INTERPOL IS OFFLINE!!!!!'
		dc.b	'DONT CALL ANYMORE!!!!!!!'
		dc.b	'SneS Rullar!! l8a dOOds!'
tlen2_A		equ	*-text2_A
tleng2_A	dc.w	0

text2_Ab;	dc.b	'------------------------'
		dc.b	'Now its my(Zacco) turn  '
		dc.b	'to to send sum perzonal '
		dc.b	'greetz...               '
		dc.b	'Jeckbuzz/Justice        '
		dc.b	' Thanx for all help...  '
		dc.b	'Exidor/Infect           '
		dc.b	' Same to you... And also'
		dc.b	' congratulations to 2nd '
		dc.b	' place on the Virtual   '
		dc.b	' party...               '
		dc.b	'Slime/Infect            '
		dc.b	'Jammie/Infect           '
		dc.b	'Chan/Independent        '
		dc.b	'                        '
		dc.b	' This time we dont send '
		dc.b	' any group greetingz... '
		dc.b	' (Vi orkar inte.. hehe) '
		dc.b	'                        '
		dc.b	'    -=:) Mystic (:=-    '
		dc.b	' - There Is No Limit! - '
tlen2_Ab	equ	*-text2_Ab
tleng2_Ab	dc.w	0
	even
xptab_A	dc.w	0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
	dc.w	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dc.w	-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
	dc.w	-1,-1,-1
	dc.w	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dc.w	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
	dc.w	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dc.w	-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
	dc.w	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dc.w	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
	dc.w	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dc.w	-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
	dc.w	0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dc.w	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
	dc.w	0,0,0,0,0,0,0,0,0,0,0,0,0
	dc.w	-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
	dc.w	0,0,0,0,0,0,0,0,0,0,0,0
	dc.w	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
	dc.w	0,0,0,0,0,0,0,0,0,0,0
	dc.w	-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
	dc.w	0,0,0,0,0,0,0,0,0,0
	dc.w	1,1,1,1,1,1,1,1,1,1,1,1,1,1
	dc.w	0,0,0,0,0,0,0,0,0
	dc.w	-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
	dc.w	0,0,0,0,0,0,0,0
	dc.w	1,1,1,1,1,1,1,1,1,1,1,1
	dc.w	0,0,0,0,0,0,0
	dc.w	-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
	dc.w	0,0,0,0,0,0
	dc.w	1,1,1,1,1,1,1,1,1,1
	dc.w	0,0,0,0,0
	dc.w	-1,-1,-1,-1,-1,-1,-1,-1,-1
	dc.w	0,0,0,0
	dc.w	1,1,1,1,1,1,1,1
	dc.w	0,0,0
	dc.w	-1,-1,-1,-1,-1,-1,-1
	dc.w	0,0
	dc.w	1,1,1,1,1,1
	dc.w	0
	dc.w	-1,-1,-1,-1,-1

yptab_A	dc.w	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dc.w	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
	dc.w	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dc.w	-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
	dc.w	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dc.w	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
	dc.w	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dc.w	-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
	dc.w	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dc.w	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
	dc.w	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dc.w	-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
	dc.w	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dc.w	1,1,1,1,1,1,1,1,1,1,1,1,1
	dc.w	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dc.w	-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
	dc.w	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dc.w	1,1,1,1,1,1,1,1,1,1,1
	dc.w	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dc.w	-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
	dc.w	0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dc.w	1,1,1,1,1,1,1,1,1
	dc.w	0,0,0,0,0,0,0,0,0,0,0,0,0
	dc.w	-1,-1,-1,-1,-1,-1,-1,-1
	dc.w	0,0,0,0,0,0,0,0,0,0,0,0
	dc.w	1,1,1,1,1,1,1
	dc.w	0,0,0,0,0,0,0,0,0,0,0
	dc.w	-1,-1,-1,-1,-1,-1
	dc.w	0,0,0,0,0,0,0,0,0,0
	dc.w	1,1,1,1,1
	dc.w	0,0,0,0,0,0,0,0,0
	dc.w	-1,-1,-1,-1
	dc.w	0,0,0,0,0,0,0,0
	dc.w	1,1,1
	dc.w	0,0,0,0,0,0,0
	dc.w	-1,-1
	dc.w	0,0,0,0,0,0
	dc.w	1
	dc.w	0,0,0,0,0

tabpos_A	dc.w	0
nxttxt_A	dc.w	0
nxttxt_Ab	dc.w	0

filled_b		dc.w	2

xp11_b		dc.w	198
yp11_b		dc.w	2
xp22_b		dc.w	319
yp22_b		dc.w	2

txtptr_b	dc.l	0
letpos_b	dc.w	8*40+26

text_b		dc.b	' Dumiskallo  ',1
		dc.b	'Mean Machine ',1
		dc.b	' System Over ',1
		dc.b	'  Hiaahhh!   ',1
		dc.b	'Hiaaah Part2 ',1
		dc.b	' Bajs E Gott ',1
		dc.b	'Software Sux ',1
		dc.b	'   Picant    ',1
		dc.b	'  Fanatica   ',1
		dc.b	'   Electra   ',1
		dc.b	'  Distanze   ',1
		dc.b	'   Testoo    ',2
tlen_b		equ	*-text_b
txtwtime	dc.w	0
txtwtimeb	dc.w	0
cleared		dc.b	0
clearedb	dc.b	0
	even
addtabwholescr	dc.w	4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,44,4,8,4,12,44
		dc.w	4,4,4,4,4,4,4,4,4,4,4,4,4,4
tocols		dc.w	$300,$aaa,$000,$000,$966,$966,$966,$966
		dc.w	$324,$fff,$c99,$fff,$855,$300,$300,$300
		dc.w	$546,$b88,$324,$855,$c99
		dc.w	$0FFF,$0CDE,$0ACD,$08AC
		dc.w	$069B,$057A,$0369,$0258
		dc.w	$0256,$0145,$0134,$0123
		dc.w	$0323,$0420,$0300
cols		=	36
fadez		dc.w	0
	even
;--------------------------------------------------------;
sin	include	'4096sin.sin'
cos	include	'4096cos.sin'
;--------------------------------------------------------;
	section	Copper,data_c
;--------------------------------------------------------;
clist	dc.w	$0100,$0200
	dc.w	$008e,$2c81,$0090,$2cc1
	dc.w	$0092,$0038,$0094,$00d0
	dc.w	$0102,$0000,$0104,$0000
	dc.w	$0108,$0000,$010a,$0000
	dc.w	$01fc,$0000

scrcols	dc.w	$0180,$0fff,$0182,$0fff,$0184,$0fff,$0186,$0fff
	dc.w	$0188,$0fff,$018a,$0fff,$018c,$0fff,$018e,$0fff
	dc.w	$0190,$0fff,$0192,$0fff,$0194,$0fff,$0196,$0fff
	dc.w	$0198,$0fff,$019a,$0fff,$019c,$0fff,$019e,$0fff
bpl	dc.w	$00e0,$0000,$00e2,$0000
	dc.w	$00e4,$0000,$00e6,$0000
bpl_a	dc.w	$00e8,$0000,$00ea,$0000
bpl_b	dc.w	$00ec,$0000,$00ee,$0000
	dc.w	$0100,$4200

balkb_b	dc.w	$0007,$fffe
	dc.w	$0190,$0fff,$0198,$0fff
balks_b	dc.w	$0007,$fffe
	dc.w	$0190,$0fff,$0198,$0fff
	dc.w	$f007,$fffe,$0100,$3200,$0184,$0fff
	dc.w	$f207,$fffe,$0100,$0200

mstbpl	dc.w	$00e0,$0000,$00e2,$0000
	dc.w	$00e4,$0000,$00e6,$0000
	dc.w	$00e8,$0000,$00ea,$0000
	dc.w	$00ec,$0000,$00ee,$0000
	dc.w	$0182,$0FFF,$0184,$0fff,$0186,$0fff,$0188,$0fff
	dc.w	$018A,$0fff,$018C,$0fff,$018E,$0fff,$0190,$0fff
	dc.w	$0192,$0fff,$0194,$0fff,$0196,$0fff,$0198,$0fff
	dc.w	$019A,$0fff,$019C,$0fff,$019E,$0fff
	dc.w	$fa07,$fffe,$0100,$4200
	dc.w	$ffe1,$fffe
	dc.w	$2507,$fffe,$0100,$0200

	dc.w	$ffff,$fffe
;--------------------------------------------------------;
	section	scrdatas,bss_c
;--------------------------------------------------------;
scr	ds.b	10240
scr2	ds.b	10240
scr_A	ds.b	256*40
scr_b	ds.b	256*40
mstscr	ds.b	43*40*4
;--------------------------------------------------------;
	section	datafiles,data_c
;--------------------------------------------------------;
font_A	incbin	'raw.font8x8'
menybak	incbin	'raw.menyback'
mod1_b	incbin	'mod.dumiskallo'
mod2_b	incbin	'mod.mean machine'
mod3_b	incbin	'mod.system_overload'
mod4	incbin	'mod.hiaahhh!'
mod5	incbin	'mod.hiaaah_part2'
mod6	incbin	'mod.de_e_gott_att_bajsa'
mod7	incbin	'mod.software_of_society'
mod8	incbin	'mod.picant'
mod9	incbin	'mod.fanatica'
mod10	incbin	'mod.electra'
mod11	incbin	'mod.distanze'
mod12	incbin	'mod.testoo'
mystlog	incbin	'raw.mystic'
;--------------------------------------------------------;
