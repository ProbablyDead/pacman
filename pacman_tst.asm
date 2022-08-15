code segment
	assume cs:code, es:code, ds:code
	org 100h
	.286
start:
jmp main	
;==========================================================
print macro mes
local s, p
push ax
push dx
mov ah, 09h
lea dx, s
int 21h
jmp p
s db mes,"$"
p:
pop dx
pop ax
endm
;==========================================================
;define
gr equ 205
vr equ 186
;==========================================================
;settings
ghostsCount dw 30
speed db 2
step dw 5 
x dw 13
y dw 15
direction db 1 

gh struc ; ghost's stucture
gx dw ?
gy dw ?
color db ?
dir db ?
gh ends

gh1 gh <>
gh2 gh <>
gh3 gh <>
gh4 gh <>
gh5 gh <>
gh6 gh <>
gh7 gh <>
gh8 gh <>
gh9 gh <>
gh10 gh <>
gh11 gh <>
gh12 gh <>
gh13 gh <>
gh14 gh <>
gh15 gh <>
gh16 gh <>
gh17 gh <>
gh18 gh <>
gh19 gh <>
gh20 gh <>
gh21 gh <>
gh22 gh <>
gh23 gh <>
gh24 gh <>
gh25 gh <>
gh26 gh <>
gh27 gh <>
gh28 gh <>
gh29 gh <>
gh30 gh <>

seed dw ?
key db "/off"
field db  201, 38 dup (gr), 184, 213, 38 dup (gr), 187,	vr, 38 dup (0), 179, 179, 38 dup (0), vr, vr, 38 dup (0), 179, 179, 38 dup (0), vr, vr, 5 dup (0), 201,	4 dup (205), 187, 6 dup(0), 201, 5 dup (205), "$"
;==========================================================
;variables
score db ?
buf db ?
counter db ?
flagDead db ?
flagAte db ?
kx dw ?
ky dw ?
gco db ?
old_1ch dd ?
old_09h dd ?
old_2fh dd ?
c db ?
d dw ?
g dw ?
cou db ?
ccl db ?
rx dw ?
ry dw ?
chngpcmn db ?
;==========================================================
new_2Fh proc far ;
    cmp     AH,0b7h         ;  è ­®¬¥à?
    jne     Pass_2Fh        ; ¥â, ­  ¢ëå®¤
    cmp     AL,00h          ; ®¤äã­ªæ¨ï ¯à®¢¥àª¨ ­  ¯®¢â®à­ãî ãáâ ­®¢ªã?
    je      inst            ; à®£à ¬¬  ã¦¥ ãáâ ­®¢«¥­ 
    cmp     AL,01h          ; ®¤äã­ªæ¨ï ¢ë£àã§ª¨?
    je      unins           ;  , ­  ¢ë£àã§ªã
    jmp     short Pass_2Fh  ; ¥¨§¢¥áâ­ ï ¯®¤äã­ªæ¨ï - ­  ¢ëå®¤
inst:
    mov     AL,0FFh         ; ®®¡é¨¬ ® ­¥¢®§¬®¦­®áâ¨ ¯®¢â®à­®© ãáâ ­®¢ª¨
    iret
Pass_2Fh:
    jmp dword PTR CS:[old_2fh]
;
; -------------- à®¢¥àª  - ¢®§¬®¦­  «¨ ¢ë£àã§ª  ¯à®£à ¬¬ë ¨§ ¯ ¬ïâ¨ ? ------
unins:
    push    BX
    push    CX
    push    DX
    push    ES
;
    mov     CX,CS   ; à¨£®¤¨âáï ¤«ï áà ¢­¥­¨ï, â.ª. á CS áà ¢­¨¢ âì ­¥«ì§ï
    mov     AX,3509h    ; à®¢¥à¨âì ¢¥ªâ®à 09h
    int     21h ; ã­ªæ¨ï 35h ¢ AL - ­®¬¥à ¯à¥àë¢ ­¨ï. ®§¢à â-¢¥ªâ®à ¢ ES:BX
;
    mov     DX,ES
    cmp     CX,DX
    jne     Not_remove
;
    cmp     BX, offset CS:new_09h
    jne     Not_remove
;
    mov     AX,351ch    ; à®¢¥à¨âì ¢¥ªâ®à 09h
    int     21h ; ã­ªæ¨ï 35h ¢ AL - ­®¬¥à ¯à¥àë¢ ­¨ï. ®§¢à â-¢¥ªâ®à ¢ ES:BX
;
    mov     DX,ES
    cmp     CX,DX
    jne     Not_remove
;
    cmp     BX, offset CS:new_1ch
    jne     Not_remove

    mov     AX,352Fh    ; à®¢¥à¨âì ¢¥ªâ®à 2Fh
    int     21h ; ã­ªæ¨ï 35h ¢ AL - ­®¬¥à ¯à¥àë¢ ­¨ï. ®§¢à â-¢¥ªâ®à ¢ ES:BX
;
    mov     DX,ES
    cmp     CX,DX
    jne     Not_remove
;
    cmp     BX, offset CS:new_2Fh
    jne     Not_remove
; ---------------------- ë£àã§ª  ¯à®£à ¬¬ë ¨§ ¯ ¬ïâ¨ ---------------------
;
    push    DS
;
    lds     DX, CS:old_09h   ; â  ª®¬ ­¤  íª¢¨¢ «¥­â­  á«¥¤ãîé¨¬ ¤¢ã¬
;    mov     DX, word ptr old_09h
;    mov     DS, word ptr old_09h+2
    mov     AX,2509h        ;  ¯®«­¥­¨¥ ¢¥ªâ®à  áâ àë¬ á®¤¥à¦¨¬ë¬
    int     21h
;
    lds     DX, CS:old_2fh   ; â  ª®¬ ­¤  íª¢¨¢ «¥­â­  á«¥¤ãîé¨¬ ¤¢ã¬
;    mov     DX, word ptr int_2Fh_vector
;    mov     DS, word ptr int_2Fh_vector+2
    mov     AX,252Fh
    int     21h

    lds     DX, CS:old_1ch   ; â  ª®¬ ­¤  íª¢¨¢ «¥­â­  á«¥¤ãîé¨¬ ¤¢ã¬
;    mov     DX, word ptr int_2Fh_vector
;    mov     DS, word ptr int_2Fh_vector+2
    mov     AX,251ch
    int     21h
;
    pop     DS
;
    mov     ES,CS:2Ch       ; ES -> ®ªàã¦¥­¨¥
    mov     AH, 49h         ; ã­ªæ¨ï ®á¢®¡®¦¤¥­¨ï ¡«®ª  ¯ ¬ïâ¨
    int     21h
;
    mov     AX, CS
    mov     ES, AX          ; ES -> PSP ¢ë£àã§¨¬ á ¬ã ¯à®£à ¬¬ã
    mov     AH, 49h         ; ã­ªæ¨ï ®á¢®¡®¦¤¥­¨ï ¡«®ª  ¯ ¬ïâ¨
    int     21h
;
    mov     AL,0Fh          ; à¨§­ ª ãá¯¥è­®© ¢ë£àã§ª¨
    jmp     short pop_ret
Not_remove:
    mov     AL,0F0h          ; à¨§­ ª - ¢ë£àã¦ âì ­¥«ì§ï
pop_ret:
    pop     ES
    pop     DX
    pop     CX
    pop     BX
    iret
new_2fh endp
;==========================================================
new_09h proc far
    pushf
	push    ax
    in      al, 60h      
    cmp     al, 4dh       
    jne      n_arrow_rigth
	jmp arrow_rigth
n_arrow_rigth:	
    cmp     al, 48h       
    jne      n_arrow_up
	jmp arrow_up
n_arrow_up:
    cmp     al, 4bh       
    jne      n_arrow_left
	jmp arrow_left
n_arrow_left:
    cmp     al, 50h       
    jne      n_arrow_down
	jmp arrow_down
n_arrow_down:
	cmp		al, 10h
	je		quit	
	cmp		al, 31h
	je		new_game	
    pop     ax      
	popf
    jmp     dword ptr cs:[old_09h]

quit:
	sti                ; ne meshaem taimeru
    in      al, 61h   
    or      al, 80h  
    out     61h, al 
    and     al, 7fh
    out     61h, al

;---------------------------------------------------------------------------
mov ax, 0b701h
int 2fh

cmp al, 0f0h ; znachit chto vigruzka nevozmojna
je not_sucsess1
cmp al, 0fh ; uspeshno vigrujena
jne not_sucsess1
mov ah, 00
mov al, 3
int 10h

not_sucsess1:
;---------------------------------------------------------------------------
	cli		; razreshaem prerivaniya
    mov     AL, 20h    
    out     20h,AL      
 
    pop     AX
	popf
iret
		
new_game: 
	sti           
    in      al, 61h   
    or      al, 80h  
    out     61h, al 
    and     al, 7fh
    out     61h, al

;---------------------------------------------------------------------------
mov ah, 0 ; reload changes, return to begin
mov al, 03h		
int 10h
mov ah, 0
mov al, 10h		
int 10h
call cs:initGhosts
mov cs:flagAte, 0
mov cs:flagDead, 0
mov cs:counter, 0	
mov cs:direction, 1
mov cs:score, 0
mov cs:buf, 0
mov cs:x, 23
mov cs:y, 23
call cs:drawGhosts
call cs:drawCandy
call cs:drawPacmen
call cs:showScore
;---------------------------------------------------------------------------
	cli		; razreshaem prerivaniya
    mov     AL, 20h    
    out     20h,AL      
 
    pop     AX
	popf
iret

arrow_rigth:
	sti                ; ne meshaem taimeru
    in      al, 61h   
    or      al, 80h  
    out     61h, al 
    and     al, 7fh
    out     61h, al

;---------------------------------------------------------------------------
mov cs:direction, 1
;---------------------------------------------------------------------------
	cli		; razreshaem prerivaniya
    mov     AL, 20h    
    out     20h,AL      
 
    pop     AX
	popf
iret


arrow_up:
	sti                ; ne meshaem taimeru
    in      al, 61h   
    or      al, 80h  
    out     61h, al 
    and     al, 7fh
    out     61h, al

;---------------------------------------------------------------------------
mov cs:direction, 2
;---------------------------------------------------------------------------
	cli		; razreshaem prerivaniya
    mov     AL, 20h    
    out     20h,AL      
 
    pop     AX
	popf
iret

arrow_left:
	sti                ; ne meshaem taimeru
    in      al, 61h   
    or      al, 80h  
    out     61h, al 
    and     al, 7fh
    out     61h, al

;---------------------------------------------------------------------------
mov cs:direction, 3
;---------------------------------------------------------------------------
	cli		; razreshaem prerivaniya
    mov     AL, 20h    
    out     20h,AL      
 
    pop     AX
	popf
iret

arrow_down:
	sti                ; ne meshaem taimeru
    in      al, 61h   
    or      al, 80h  
    out     61h, al 
    and     al, 7fh
    out     61h, al

;---------------------------------------------------------------------------
mov cs:direction, 4
;---------------------------------------------------------------------------
	cli		; razreshaem prerivaniya
    mov     AL, 20h    
    out     20h,AL      
 
    pop     AX
	popf
iret
new_09h endp
;==========================================================
showScore proc far
mov ah, 02 ; set cursor position
mov bh, 0
mov dh, 24
mov dl, 77
int 10h

cmp cs:score, 0
je zero

mov cl, cs:score ; translation to hex by skip all letters 
mov cs:buf, 0
xor ch, ch
l1:	
inc cs:buf ; 
mov dl, cs:buf
and dl, 0fh
cmp dl, 0ah
jne ll1
add cs:buf, 6
ll1:
loop l1
lll1:

zero:
mov dl, cs:buf ; if first letter equ 0, return space 
and dl, 0f0h
rcr dl, 4
add dl, 30h	
cmp dl, 30h
jne dd1
mov dl, " "
dd1:

mov ah, 09h ; write first letter
mov al, dl
mov bh, 0
mov bl, 0eh
mov cx, 1
int 10h

mov ah, 02 ; move cursor
mov bh, 0
mov dh, 24
mov dl, 78
int 10h

mov dl, cs:buf ; write second letter
and dl, 0fh
add dl, 30h	

mov ah, 09h
mov al, dl
mov bh, 0
mov bl, 0eh ; write second letter
mov cx, 1
int 10h

mov ah, 02 ; hide cursor
mov bh, 0
mov dh, 30
int 10h
ret
showScore endp
;==========================================================
createCandy proc far
pusha
call cs:rand8 ; create candy's x value
mov bl, 3
mul bl
mov cs:kx, ax

call cs:rand8 ; create candy's y value, I used a adding to coordinate, because al's max value is 255, but window's size is 640x450
mov bx, 445
add ax, bx
mov bx, 350
div bx
mov cs:ky, dx
popa
ret
createCandy endp
;==========================================================
clearCandy proc far ; candy is 5x5 pixels
mov ax, 0c00h ; mov al, 0 == black color
mov bh, 0
mov cx, cs:kx
mov dx, cs:ky

sub dx, 2
sub cx, 2

mov cs:gco, 5
pusha
call cs:fillCol
popa 

inc cx
mov cs:gco, 5
pusha
call cs:fillCol
popa

inc cx
mov cs:gco, 5
pusha
call cs:fillCol
popa

inc cx
mov cs:gco, 5
pusha
call cs:fillCol
popa

inc cx
mov cs:gco, 5
pusha
call cs:fillCol
popa

ret
clearCandy endp
;==========================================================
drawCandy proc far ; the same as clearCandy, but collor is white
mov ax, 0c0fh
mov bh, 0
mov cx, cs:kx
mov dx, cs:ky

sub dx, 2
sub cx, 2

mov cs:gco, 5
pusha
call cs:fillCol
popa 

inc cx
mov cs:gco, 5
pusha
call cs:fillCol
popa

inc cx
mov cs:gco, 5
pusha
call cs:fillCol
popa

inc cx
mov cs:gco, 5
pusha
call cs:fillCol
popa

inc cx
mov cs:gco, 5
pusha
call cs:fillCol
popa

ret
drawCandy endp
;==========================================================
check proc far ; looking for any colors next to pacman in 13x1 area
mov ah, 0dh
mov bh, 0
mov dx, cs:y
mov cx, cs:x

	cmp cs:direction, 1
jne ka1
add cx, 6
sub dx, 6
mov cs:cou, 13

chk1:
cmp cs:cou, 0
je cho1
int 10h

cmp al, 0 ; if color is black, skip pixel
jne isd1
jmp ok1
isd1:

cmp al, 0eh ; if color is yellow, skip pixel
jne isd10
jmp ok1
isd10:

cmp al, 0fh ; if color is white, this means, that we have met a candy
jne nk1
mov cs:flagAte, 1
inc cs:score
jmp ka
nk1:

mov cs:flagDead, 1 ; if we get any other color - we meet a ghost

ok1:
inc dx
dec cs:cou
inc cx
loop chk1
cho1:

jmp ka
ka1:

	cmp cs:direction, 2 ; the same thing with other directions
jne ka2
sub cx, 6
sub dx, 6
mov cs:cou, 13

chk2:
cmp cs:cou, 0
je cho2
int 10h

cmp al, 0
jne isd2
jmp ok2
isd2:

cmp al, 0eh
jne isd20
jmp ok2
isd20:

cmp al, 0fh
jne nk2
mov cs:flagAte, 1
inc cs:score
jmp ka
nk2:

mov cs:flagDead, 1

ok2:
inc cx
dec cs:cou
inc cx
loop chk2
cho2:

jmp ka
ka2:

	cmp cs:direction, 3; the same thing with other directions
jne ka3
sub cx, 6
sub dx, 6
mov cs:cou, 13

chk3:
cmp cs:cou, 0
je cho3
int 10h

cmp al, 0
jne isd3
jmp ok3
isd3:

cmp al, 0eh
jne isd30
jmp ok3
isd30:

cmp al, 0fh
jne nk3
mov cs:flagAte, 1
inc cs:score
jmp ka
nk3:

mov cs:flagDead, 1

ok3:
inc dx
dec cs:cou
inc cx
loop chk3
cho3:

jmp ka
ka3:

	cmp cs:direction, 4; the same thing with other directions
jne ka4
sub cx, 6
add dx, 6
mov cs:cou, 13

chk4:
cmp cs:cou, 0
je cho4
int 10h

cmp al, 0
jne isd4
jmp ok4
isd4:

cmp al, 0eh
jne isd40
jmp ok4
isd40:

cmp al, 0fh
jne nk4
mov cs:flagAte, 1
inc cs:score
jmp ka
nk4:

mov cs:flagDead, 1

ok4:
inc cx
dec cs:cou
inc cx
loop chk4
cho4:

jmp ka
ka4:

ka:

ret
check endp
;==========================================================
new_1ch proc far

cmp cs:flagDead, 1 ; if we've met a ghost, game over
je itsfc
jmp itsok
itsfc:
mov ah, 02h ; set coursor position
mov bh, 0
mov dl, 35
mov dh, 11
int 10h

mov dl, "G"
int 21h
mov dl, "A"
int 21h
mov dl, "M"
int 21h
mov dl, "E"
int 21h
mov dl, " "
int 21h
mov dl, "O"
int 21h
mov dl, "V"
int 21h
mov dl, "E"
int 21h
mov dl, "R"
int 21h
mov dl, "!"
int 21h

mov ah, 02h ; set coursor position 
mov bh, 0
mov dl, 33
mov dh, 12
int 10h

mov dl, "Y"
int 21h
mov dl, "o"
int 21h
mov dl, "u"
int 21h
mov dl, "r"
int 21h
mov dl, " "
int 21h
mov dl, "s"
int 21h
mov dl, "c"
int 21h
mov dl, "o"
int 21h
mov dl, "r"
int 21h
mov dl, "e"
int 21h
mov dl, ":"
int 21h
mov dl, " "
int 21h

cmp cs:score, 0 ; 
je Ezero

mov cl, cs:score
mov cs:buf, 0
xor ch, ch
El1:	
inc cs:buf
mov dl, cs:buf
and dl, 0fh
cmp dl, 0ah
jne Ell1
add cs:buf, 6
Ell1:
loop El1
Elll1:

Ezero:
mov dl, cs:buf
and dl, 0f0h
rcr dl, 4
add dl, 30h	
cmp dl, 30h
jne Edd1
mov dl, " "
Edd1:

mov ah, 09h
mov al, dl
mov bh, 0
mov bl, 0eh
mov cx, 1
int 10h

mov ah, 02
mov bh, 0
mov dh, 12
mov dl, 46
int 10h

mov dl, cs:buf
and dl, 0fh
add dl, 30h	

mov ah, 09h
mov al, dl
mov bh, 0
mov bl, 0eh
mov cx, 1
int 10h

mov ah, 02 ; clear bottom score
mov bh, 0
mov dh, 24
mov dl, 77
int 10h

mov ah, 09h
mov al, 0
mov bh, 0
mov bl, 0h
mov cx, 1
int 10h

mov ah, 02
mov bh, 0
mov dh, 24
mov dl, 78
int 10h

mov ah, 09h
mov al, 0
mov bh, 0
mov bl, 0h
mov cx, 1
int 10h

jmp next
itsok:

mov  bl, cs:speed ; FPS
cmp cs:counter, bl
je n_next
jmp next
n_next:
mov bx, cs:step
mov cs:counter, 0

call cs:showScore
call cs:check
cmp cs:flagAte, 1
jne didnteat
call cs:clearCandy
call cs:createCandy
mov cs:flagAte, 0
didnteat:

call cs:drawCandy
call cs:clearGhosts
call cs:clearPacmen
call cs:changeGhosts
call cs:drawGhosts

	cmp cs:direction, 1 ; change pacmen's position
jne h1
add cs:x, bx
jmp h
h1:

	cmp cs:direction, 2
jne h2
sub cs:y, bx
jmp h
h2:

	cmp cs:direction, 3
jne h3
sub cs:x, bx
jmp h
h3:

	cmp cs:direction, 4
jne h4
add cs:y, bx
jmp h
h4:
h:


cmp cs:chngpcmn, 1
je dfp
mov cs:chngpcmn, 1
mov dx, cs:y
mov cx, cs:x
call cs:drawPacmen 
jmp next
dfp:
mov cs:chngpcmn, 0
mov dx, cs:y
mov cx, cs:x
call cs:drawFullPucmen; shut pacman's mouth
;===========

next:
inc cs:counter
jmp dword ptr cs:[old_1ch]
new_1ch endp
;==========================================================
drawPacmen proc far  
push ds ; mov to ds cs, for not to write "cs:"
push cs
pop ds
push si

mov ax, 0c0eh
mov bh, 0

cmp direction, 1 ; choose vector
jne n1
mov rx, 1
mov ry, 0
jmp n
n1:

cmp direction, 2
jne n2
mov rx, 0
mov ry, 1
neg ry
jmp n
n2:

cmp direction, 3
jne n3
mov rx, 1
neg rx
mov ry, 0
jmp n
n3:

cmp direction, 4
jne n4
mov rx, 0
mov ry, 1
jmp n
n4:
n:

cmp rx, 0
jne s1
lea si, x
jmp s
s1:

cmp ry, 0
jne s2
lea si, y
jmp s
s2:
s:

push x ; draw bottom pacman's half
push y
mov g, 1

mov dx, y
mov cx, x
;======
sub dx, ry
sub cx, rx
sub dx, ry
sub cx, rx

mov cou, 4
call cs:fill_str

mov ccl, 0
mov cou, 6
call cs:set_line

mov ccl, 3
mov cou, 9
call cs:set_line

mov ccl, 5
mov cou, 10 
call cs:set_line

mov ccl, 5
mov cou, 10 
call cs:set_line

mov ccl, 4
mov cou, 8 
call cs:set_line

mov ccl, 2
mov cou, 4 
call cs:set_line
;======
pop y
pop x
;==============================
push x ; draw upper pacman's half
push y
mov g, 0

mov dx, y
mov cx, x
;======
sub dx, ry
sub cx, rx
sub dx, ry
sub cx, rx

mov cou, 4
call cs:fill_str

mov ccl, 0
mov cou, 6
call cs:set_line

mov ccl, 3
mov cou, 9
call cs:set_line

mov ccl, 5
mov cou, 10 
call cs:set_line

mov ccl, 5
mov cou, 10 
call cs:set_line

mov ccl, 4
mov cou, 8 
call cs:set_line

mov ccl, 2
mov cou, 4 
call cs:set_line
;======
pop y
pop x
push x
push y

sub word ptr [si], 4 ; draw eye
mov dx, y
mov cx, x

mov al, 0
sub cx, rx
sub dx, ry
int 10h
sub dx, ry
sub cx, rx
int 10h

inc word ptr [si]
mov dx, y
mov cx, x
sub dx, ry
sub cx, rx
int 10h
sub dx, ry
sub cx, rx
int 10h
;======
pop y
pop x
pop si
pop ds
ret
drawPacmen endp
;==========================================================
set_line proc far ; draw line
cmp cs:g, 1
jne j1
inc word ptr cs:[si]
jmp j
j1:
dec word ptr cs:[si]
j:
mov dx, cs:y
mov cx, cs:x
cll:
cmp ccl, 0
je ol
add dx, cs:ry
add cx, cs:rx
dec ccl
inc cx
loop cll
ol:
call cs:fill_str
ret
set_line endp
;==========================================================
fill_str proc far
cc:
cmp cs:cou, 0
je oo
sub dx, cs:ry
sub cx, cs:rx
int 10h
dec cs:cou
inc cx
loop cc
oo:
ret
fill_str endp
;==========================================================
clearPacmen proc far ; the same as clear pacman, but colour is black
push ds
push cs
pop ds
push si

mov ax, 0c00h
mov bh, 0

cmp direction, 1
jne n5
mov rx, 1
mov ry, 0
jmp n0
n5:

cmp direction, 2
jne n6
mov rx, 0
mov ry, 1
neg ry
jmp n0
n6:

cmp direction, 3
jne n7
mov rx, 1
neg rx
mov ry, 0
jmp n0
n7:

cmp direction, 4
jne n8
mov rx, 0
mov ry, 1
jmp n0
n8:
n0:

cmp rx, 0
jne s3
lea si, x
jmp s0
s3:

cmp ry, 0
jne s4
lea si, y
jmp s0
s4:
s0:

push x
push y
mov g, 1

mov dx, y
mov cx, x
;======
add dx, ry
add cx, rx
add dx, ry
add cx, rx
add dx, ry
add cx, rx
add dx, ry
add cx, rx
add dx, ry
add cx, rx
add dx, ry
add cx, rx
add dx, ry
add cx, rx
mov cou, 13
call fill_str

mov cou, 13
mov ccl, 7
call set_line

mov cou, 13
mov ccl, 7
call set_line

mov cou, 13
mov ccl, 7
call set_line

mov cou, 13
mov ccl, 7
call set_line

mov cou, 13
mov ccl, 7
call set_line

mov cou, 13
mov ccl, 7
call set_line
;======
pop y
pop x
;==============================
push x
push y
mov g, 0

mov dx, y
mov cx, x
;======
mov cou, 13
mov ccl, 7
call set_line

mov cou, 13
mov ccl, 7
call set_line

mov cou, 13
mov ccl, 7
call set_line

mov cou, 13
mov ccl, 7
call set_line

mov cou, 13
mov ccl, 7
call set_line

mov cou, 13
mov ccl, 7
call set_line
;======
pop y
pop x
pop si
pop ds
ret
clearPacmen endp
;==========================================================
drawFullPucmen proc far 
push ds
push cs
pop ds
push si

mov ax, 0c0eh
mov bh, 0

cmp direction, 1
jne d1
mov rx, 1
mov ry, 0
jmp d0
d1:

cmp direction, 2
jne d2
mov rx, 0
mov ry, 1
neg ry
jmp d0
d2:

cmp direction, 3
jne d3
mov rx, 1
neg rx
mov ry, 0
jmp d0
d3:

cmp direction, 4
jne d4
mov rx, 0
mov ry, 1
jmp d0
d4:
d0:

cmp rx, 0
jne r1
lea si, x
jmp r
r1:

cmp ry, 0
jne r2
lea si, y
jmp r
r2:
r:

push x
push y
mov g, 1

mov dx, y
mov cx, x
;======
add dx, ry
add cx, rx
add dx, ry
add cx, rx
add dx, ry
add cx, rx
mov cou, 9
call cs:fill_str

mov ccl, 6
mov cou, 12
call cs:set_line

mov ccl, 6
mov cou, 12
call cs:set_line

mov ccl, 5
mov cou, 10 
call cs:set_line

mov ccl, 5
mov cou, 10 
call cs:set_line

mov ccl, 4
mov cou, 8 
call cs:set_line

mov ccl, 2
mov cou, 4 
call cs:set_line
;======
pop y
pop x
;==============================
push x
push y
mov g, 0

mov dx, y
mov cx, x
;======

mov ccl, 6
mov cou, 12
call cs:set_line

mov ccl, 6
mov cou, 12
call cs:set_line

mov ccl, 5
mov cou, 10 
call cs:set_line

mov ccl, 5
mov cou, 10 
call cs:set_line

mov ccl, 4
mov cou, 8 
call cs:set_line

mov ccl, 2
mov cou, 4 
call cs:set_line
;======
pop y
pop x
push x
push y

sub word ptr [si], 4
mov dx, y
mov cx, x

mov al, 0
sub cx, rx
sub dx, ry
int 10h
sub dx, ry
sub cx, rx
int 10h

inc word ptr [si]
mov dx, y
mov cx, x
sub dx, ry
sub cx, rx
int 10h
sub dx, ry
sub cx, rx
int 10h
;======
pop y
pop x
pop si
pop ds
ret
drawFullPucmen endp
;==========================================================
fillCol proc far
gp:
cmp cs:gco, 0
je goc
int 10h
inc dx
inc cx
dec cs:gco
loop gp
goc:
ret
fillCol endp
;==========================================================
clearGhosts proc far ; same as drawGhosts, but color is black, it can be optimised, but i'm lazy :(
push ds
push cs
pop ds
mov cx, ghostsCount
mov di, 0 

dgc0:
cmp cx, 0
jne conti0
jmp oud0

conti0:
push cx
mov ah, 0ch
mov al, 0
mov bh, 0

mov dx, word ptr cs:gh1.gy+di 
mov cx, word ptr cs:gh1.gx+di

sub dx, 2
sub cx, 5

mov gco, 11
call fillCol

inc cx
sub dx, 12
mov gco, 2
call fillCol

mov al, 00h
int 10h
inc dx
mov al, 0
int 10h
inc dx
int 10h
inc dx

mov al, 0 
mov gco, 6
call fillCol

inc cx
sub dx, 12

mov gco, 3
call fillCol

mov al, 00h
mov gco, 3
call fillCol

mov al, 0
mov gco, 5
call fillCol

inc cx
sub dx, 12

mov gco, 4
call fillCol

mov al, 00h
mov gco, 3
call fillCol

mov al, 0
mov gco, 5
call fillCol

inc cx
sub dx, 12

mov gco, 13
call fillCol

inc cx
sub dx, 13

mov gco, 13
call fillCol

inc cx
sub dx, 13
mov gco, 4
call fillCol

mov al, 00h
int 10h
inc dx
mov al, 0
int 10h
inc dx
int 10h
inc dx

mov al, 0
mov gco, 6
call fillCol

inc cx
sub dx, 13

mov gco, 4
call fillCol

mov al, 00h
mov gco, 3
call fillCol

mov al, 0
mov gco, 6
call fillCol

inc cx
sub dx, 12
mov gco, 3
call fillCol

mov al, 00h
mov gco, 3
call fillCol

mov al, 0
mov gco, 7
call fillCol

inc cx
sub dx, 12
mov gco, 12
call fillCol

inc cx
sub dx, 11
mov gco, 12
call fillCol

add di, 6
pop cx
dec cx
jmp dgc0
oud0:


pop ds
ret
clearGhosts endp
;==========================================================
drawGhosts proc far
push ds
push cs
pop ds
mov cx, ghostsCount
mov di, 0 

dgc:
cmp cx, 0
jne conti
jmp oud

conti:
push cx
mov ah, 0ch
mov al, byte ptr cs:gh1.color+di
mov bh, 0

mov dx, word ptr cs:gh1.gy+di
mov cx, word ptr cs:gh1.gx+di

sub dx, 2
sub cx, 5

mov gco, 11
call fillCol

inc cx
sub dx, 12
mov gco, 2
call fillCol

mov al, 07h
int 10h
inc dx
mov al, 8
int 10h
inc dx
int 10h
inc dx

mov al, byte ptr cs:gh1.color+di
mov gco, 6
call fillCol

inc cx
sub dx, 12

mov gco, 3
call fillCol

mov al, 07h
mov gco, 3
call fillCol

mov al, byte ptr cs:gh1.color+di
mov gco, 5
call fillCol

inc cx
sub dx, 12

mov gco, 4
call fillCol

mov al, 07h
mov gco, 3
call fillCol

mov al, byte ptr cs:gh1.color+di
mov gco, 5
call fillCol

inc cx
sub dx, 12

mov gco, 13
call fillCol

inc cx
sub dx, 13

mov gco, 13
call fillCol

inc cx
sub dx, 13
mov gco, 4
call fillCol

mov al, 07h
int 10h
inc dx
mov al, 8
int 10h
inc dx
int 10h
inc dx

mov al, byte ptr cs:gh1.color+di
mov gco, 6
call fillCol

inc cx
sub dx, 13

mov gco, 4
call fillCol

mov al, 07h
mov gco, 3
call fillCol

mov al, byte ptr cs:gh1.color+di
mov gco, 6
call fillCol

inc cx
sub dx, 12
mov gco, 3
call fillCol

mov al, 07h
mov gco, 3
call fillCol

mov al, byte ptr cs:gh1.color+di
mov gco, 7
call fillCol

inc cx
sub dx, 12
mov gco, 12
call fillCol

inc cx
sub dx, 11
mov gco, 12
call fillCol

add di, 6
pop cx
dec cx
jmp dgc
oud:


pop ds
ret
drawGhosts endp
;==========================================================
rand8	proc near
push bx
push cx
push dx
		mov	AX,		word ptr	cs:seed
		mov	CX,		8	

newbit:	mov	BX,		AX
		and	BX,		002Dh
		xor	BH,	BL
		clc
		jpe	shift
		stc
shift:	rcr	AX,	1
	loop	newbit
	mov	word	ptr	cs:seed,	AX
	mov	AH,	0
pop dx
pop cx
pop bx
	ret
rand8 endp
;==========================================================
initGhosts proc far
mov cx, cs:ghostsCount
mov si, 0
ic:
push cx	

call rand8 ; get ghost x position
mov bl, 3
mul bl
mov cs:gh1.gx+si, ax
call rand8 ; get ghost y position
mov cs:gh1.gy+si, ax
ntc:
call rand8 ; get ghost's colour
and al, 0fh
cmp al, 0fh
je ntc
cmp al, 0
je ntc
cmp al, 0eh
je ntc

mov cs:gh1.color+si, al
add si, 6
pop cx
loop ic
ret
initGhosts endp
;==========================================================
changeGhosts proc far ; change ghost's pos
mov cx, cs:ghostsCount
mov si, 0

ic0:
push cx

call cs:rand8
mov bl, 5
div bl

cmp cs:gh1.gx+si, 626 ; don't let them go out of walls
jle di1
mov ah, 3
jmp di0
di1:

cmp cs:gh1.gx+si, 13
jge di2
mov ah, 1
jmp di0
di2:

cmp cs:gh1.gy+si, 13
jge di3
mov ah, 4
jmp di0
di3:

cmp cs:gh1.gy+si, 336
jle di4
mov ah, 2
jmp di0
di4:
di0:

mov bx, cs:step 
cmp ah, 1
jne y1
add cs:gh1.gx+si, bx
jmp y0
y1:

cmp ah, 2
jne y2
sub cs:gh1.gy+si, bx
jmp y0
y2:

cmp ah, 3
jne y3
sub cs:gh1.gx+si, bx
jmp y0
y3:

cmp ah, 4
jne y4
add cs:gh1.gy+si, bx

jmp y0
y4:
y0:
add si, 6
pop cx
loop ic0

ret
changeGhosts endp
;==========================================================
main:
mov ax, 0b700h ; proveryaem na povtornuy zagruzku
int 2fh

cmp al, 0ffh ; uje ustanovlena
jne nice
print "already installed"
int 20h
;==========================================================
;set par
	nice:
	mov ah, 0 ; get random seed for rand8
	int 1ah
	mov cs:seed, dx

	mov ah, 0 ; set mode 640x450
	mov al, 10h
	int 10h
	
	mov ah, 02h ; mov cursor to 0;0
	mov dh, 0
	mov dl, 0
	mov bh, 0
	int 10h
	
	call createCandy
	call initGhosts
	call drawGhosts
	call drawPacmen
	call drawCandy

	mov ah, 02h ; hide cursor
	mov dh, 30
	mov bh, 0
	int 10h
	
;==========================================================

;==========================
;TSR
	mov ax, 351ch ; get 1ch interruption vector
	int 21h

	mov word ptr cs:[old_1ch], bx ; save
	mov word ptr cs:[old_1ch]+2, es
	lea dx, new_1ch
	mov ax, 251ch ; set new 1ch vector
	int 21h

	mov ax, 3509h; get 09h interruption vector
	int 21h

	mov word ptr cs:[old_09h], bx; save
	mov word ptr cs:[old_09h]+2, es
	lea dx, new_09h
	mov ax, 2509h ; set new 09h vector
	int 21h

	mov ax, 352fh; get 2fh interruption vector
	int 21h

	mov word ptr cs:[old_2fh], bx; save
	mov word ptr cs:[old_2fh]+2, es
	lea dx, new_2fh
	mov ax, 252fh; set new 2fh vector
	int 21h

	lea dx, main ; leave program  
	int 27h
;==========================================================
	mov ah, 4ch
	int 21h
code ends
	end start
