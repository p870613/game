INCLUDE Irvine32.inc

.386
.model flat, stdcall

.stack 4096
ExitProcess PROTO, dwexitcode:DWORD

.data
w = 50
h = 25
mazesize = 1250
ratio = 30
s = 50
d = 1199
maze byte 1875 dup(?) ; 1為障礙物 0是路 2是人 3是目標 4是怪獸 5是分數
pos dword 50
visit dword 10000 dup(?)
re byte 1250 dup(0);1為造訪過 0為無
count dword 0
che byte 0
str1 byte "      Score: ",0
score dword 0
str2 byte "Congratulate!!!! you win.",0
str3 byte "you are lost",0
stituation byte 0;
rule byte "The rule of game:",0dh,0ah, 
		  "1. There are four instrution.",
		  " W is up.",
		  " S is down.",
		  " D is right.",
		  "  A is left.",0dh,0ah,
		  "2. You are the white block at the left top. When you reach to the destination,the blue block, you will win.",0dh,0ah,
		  "3. The red block are walls which cannot pass it, the black block is road, and the yellow - is score",0dh,0ah,
		  "4. The green @ is monsters. When you touch them, the game will be over.",0dh,0ah,0
.code
main proc
	
	call Randomize
	
bwhile:

	call build
	;call Clrscr
	;call print
	
	push 50;
	mov re[50], 1
	inc count

	bbfs:
		.if(che == 1)
			jmp endbfs;
		.endif

		.if(count == mazesize)
			jmp endbfs;
		.endif
		.if(count == 0)
			jmp endbfs;
		.endif

		pop eax

		dec count
		;右
		mov edx, eax;
		inc edx;

		.if(edx >= 0 && edx < mazesize && re[edx] == 0)
			cmp maze[edx], 0
			je L1
			
			cmp maze[edx], 3
			je L2
			jne L3

			L1:
			push edx
			;mov maze[edx], 2
			mov re[edx], 1
			inc count
			jmp L3
			L2:
			mov che, 1

			L3:
		.endif
		 
		 ;左
		 mov edx, eax;
		 dec edx;

		.if(edx >= 0 && edx < mazesize && re[edx] == 0)
			cmp maze[edx], 0
			je L4
			;jne L6

			cmp maze[edx], 3
			je L5
			jne L6

			L4:
			push edx
			;mov maze[edx], 2
			mov re[edx], 1
			inc count
			jmp L6
			L5:
			mov che, 1
			L6:

		.endif

		;下
		mov edx, eax;
		add edx, w;

		.if(edx >= 0 && edx < mazesize && re[edx] == 0)
			cmp maze[edx], 0
			je L7
			;jne L9

			cmp maze[edx], 3
			je L8
			jne L9

			L7:
			push edx
			mov re[edx], 1
			;mov maze[edx], 2
			inc count
			jmp L9
			L8:
			mov che, 1

			L9:
		.endif

		;下
		mov edx, eax;
		sub edx, w;

		.if(edx >= 0 && edx < mazesize && re[edx] == 0)
			cmp maze[edx], 0
			je L10
			;jne L12

			cmp maze[edx], 3
			je L11
			jne L12

			L10:
			push edx
			mov re[edx], 1
			;mov maze[edx], 2
			inc count
			jmp L12
			L11:
			mov che, 1

			L12:
		.endif
	;call print;
	jmp bbfs
	endbfs:
	;call print;
	.if(che == 1)
		jmp endwhile;
	.endif

	jmp bwhile

endwhile:
	mov edx ,offset rule
	call writestring

start:
	
	call print
	call master_move
	call readkey;
	jnz startend
	;mov eax, 1000;
	;call delay
	
jmp start
startend:
	call move
	jmp start
endgame::
	call print
	call crlf
	call crlf
	.if(stituation == 1)
		mov edx ,offset str2
		call writestring
	.endif

	.if(stituation == 2)
		mov edx ,offset str3
		call writestring
	.endif
	call crlf
	call crlf
	
	call waitmsg
	Invoke ExitProcess, 0

main endp
move proc uses ecx edi
.if(al == 'D' || al == 'd')
		mov ecx, pos
		mov edi, pos
		add edi, 1
		.if(edi >= 0 && edi <= 1199 && maze[edi] == 5)
			mov pos, edi
			mov maze[edi], 2
			mov maze[ecx], 0
			inc score
		.endif
		.if(edi >= 0 && edi <= 1199 && maze[edi] == 3)
			mov pos, edi
			mov maze[edi], 2
			mov maze[ecx], 0
			mov stituation, 1
			jmp endgame
		.endif
		.if(edi >= 0 && edi < 1199 && maze[edi] == 4)
			mov pos, edi
			mov maze[edi], 4
			mov maze[ecx], 0
			mov stituation, 2
			jmp endgame
		.endif
		.if(edi >= 0 && edi < 1199 && maze[edi] == 0)
			mov pos, edi
			mov maze[edi], 2
			mov maze[ecx], 0
		.endif	
	.endif
	
	.if(al == 'W' || al == 'w')
		mov ecx, pos
		mov edi, pos
		sub edi, w
		.if(edi >= 0 && edi <= 1199 && maze[edi] == 5)
			mov pos, edi
			mov maze[edi], 2
			mov maze[ecx], 0
			inc score
		.endif

		.if(edi >= 0 && edi < 1199 && maze[edi] == 4)
			mov pos, edi
			mov maze[edi], 4
			mov maze[ecx], 0
			mov stituation, 2
			jmp endgame
		.endif
		.if(edi >= 0 && edi <= 1199 && maze[edi] == 3)
			mov pos, edi
			mov maze[edi], 2
			mov maze[ecx], 0
			mov stituation, 1
			jmp endgame
		.endif
		.if(edi >= 0 && edi < 1199 && maze[edi] == 0)
			mov pos, edi
			mov maze[edi], 2
			mov maze[ecx], 0
		.endif	
	.endif

	.if(al == 's' || al == 'S')
		mov ecx, pos
		mov edi, pos
		add edi, w
		.if(edi >= 0 && edi <= 1199 && maze[edi] == 5)
			mov pos, edi
			mov maze[edi], 2
			mov maze[ecx], 0
			inc score
		.endif

		.if(edi >= 0 && edi < 1199 && maze[edi] == 4)
			mov pos, edi
			mov maze[edi], 4
			mov maze[ecx], 0
			mov stituation, 2
			jmp endgame
		.endif
		.if(edi >= 0 && edi <= 1199 && maze[edi] == 3)
			mov pos, edi
			mov maze[edi], 2
			mov maze[ecx], 0
			mov stituation, 1
			jmp endgame
		.endif
		.if(edi >= 0 && edi < 1199 && maze[edi] == 0)
			mov pos, edi
			mov maze[edi], 2
			mov maze[ecx], 0
		.endif	
	.endif

	.if(al == 'a' || al == 'A')
		mov ecx, pos
		mov edi, pos
		sub edi, 1
		.if(edi >= 0 && edi <= 1199 && maze[edi] == 5)
			mov pos, edi
			mov maze[edi], 2
			mov maze[ecx], 0
			inc score
		.endif

		.if(edi >= 0 && edi < 1199 && maze[edi] == 4)
			mov pos, edi
			mov maze[edi], 4
			mov maze[ecx], 0
			mov stituation, 2
			jmp endgame
		.endif
		.if(edi >= 0 && edi <= 1199 && maze[edi] == 3)
			mov pos, edi
			mov maze[edi], 2
			mov maze[ecx], 0
			mov stituation, 1
			jmp endgame
		.endif
		.if(edi >= 0 && edi < 1199 && maze[edi] == 0)
			mov pos, edi
			mov maze[edi], 2
			mov maze[ecx], 0
		.endif	
	.endif
ret
move endp 

master_move proc uses ecx eax ebx esi
mov ecx, 1199
L1:
	cmp maze[ecx], 4
	je  L2 
	L3:
loop L1
jmp L4
L2:
mov ebx, ecx;
mov eax, 4;
call randomrange;

.if(eax == 0)
	mov esi, ebx
	inc esi;
	.if(esi > 50 && esi < 1199 && maze[esi] == 0)
		mov maze[esi], 4;
		mov maze[ebx], 0;
	.endif
	.if(esi > 50 && esi < 1199 && maze[esi] == 2)
		mov maze[esi], 4;
		mov maze[ebx], 0;
		mov stituation, 2
		jmp endgame
	.endif
.endif

.if(eax == 1)
	mov esi, ebx
	dec esi;
	.if(esi > 50 && esi < 1199 && maze[esi] == 2)
		mov maze[esi], 4;
		mov maze[ebx], 0;
		mov stituation, 2
		jmp endgame
	.endif
	.if(esi > 50 && esi < 1199 && maze[esi] == 0)
		mov maze[esi], 4;
		mov maze[ebx], 0;
		dec ecx
	.endif
.endif

.if(eax == 2)
	mov esi, ebx
	add esi, w;
	.if(esi > 50 && esi < 1199 && maze[esi] == 2)
		mov maze[esi], 4;
		mov maze[ebx], 0;
		mov stituation, 2
		jmp endgame
	.endif
	.if(esi > 50 && esi < 1199 && maze[esi] == 0)
		mov maze[esi], 4;
		mov maze[ebx], 0;
	.endif
.endif
.if(eax == 3)
	mov esi, ebx
	sub esi, w;
	.if(esi > 50 && esi < 1199 && maze[esi] == 2)
		mov maze[esi], 4;
		mov maze[ebx], 0;
		mov stituation, 2
		jmp endgame
	.endif
	.if(esi > 50 && esi < 1199 && maze[esi] == 0)
		mov maze[esi], 4;
		mov maze[ebx], 0;
		sub ecx, w;
	.endif
.endif
jmp L3
L4:
ret
master_move endp


build proc uses esi ecx eax ebx


	mov ecx, h;
	mov esi, 0

L1:                     ;build maze
	mov ebx, ecx
	mov ecx, w;
	L2:
		mov eax, 100;
		call randomrange

		cmp eax, ratio
		ja L3
		jmp L4
		L4:
			mov maze[esi], 1;障礙
			jmp L5
		L3: 
			mov maze[esi], 0;路
		L5:
		mov re[esi], 0
		inc esi
	loop L2
	mov ecx ,ebx
loop L1
;邊框
mov ecx, w
mov esi, 0
L6:
	mov maze[esi], 1;
	inc esi
loop L6

mov ecx, w
mov esi, 1200
L7:
	mov maze[esi], 1;
	inc esi
loop L7

mov ecx, h
mov esi, 0
L8:
	mov maze[esi], 1;
	add esi, w
loop L8

mov ecx, h
mov esi, 49
L9:
	mov maze[esi], 1;
	add esi, w
loop L9
;end邊框
;怪物
mov ecx, 8

L10:
mov eax, 1100
call randomrange
add eax, 100
mov maze[eax], 4
loop L10
;end怪物
mov ecx, 50

L11:
mov eax, 1100
call randomrange
add eax, 100
mov maze[eax], 5
loop L11
	mov maze[50], 2;
	mov maze[1199], 3

ret
build endp 


print proc uses eax
	push edx
	push esi
	push ecx
	
	mov dl, 0
	mov dh, 5
	call gotoxy

	mov esi, 0
	mov ecx, h

L1:                    ;print
	cmp ecx, 0
	je endl1
	push ecx
	mov ecx, w;
	L2:
		cmp ecx, 0
		je endl2
		movzx eax, maze[esi]
		cmp eax, 0
		je L3
		cmp eax, 1
		je L4
		cmp eax, 2
		je L5
		cmp eax, 3
		je L7
		cmp eax, 4
		je L8
		cmp eax, 5
		je L9

		L4:
			mov eax, 68
			call settextcolor
			mov al, maze[esi];
			call WriteChar
			mov eax, 15
			call settextcolor
 
			jmp L6
		L3: 
			mov eax, 0
			call settextcolor
			mov al, maze[esi]
			call WriteChar
			mov eax, 15
			call settextcolor
			jmp L6
		L5:
			mov eax, 255
			call settextcolor
			mov al, maze[esi]
			call WriteChar
			mov eax, 15
			call settextcolor
			jmp L6
		L7:
			mov eax, 154
			call settextcolor
			mov al, maze[esi]
			call WriteChar
			mov eax, 15
			call settextcolor
			jmp L6
		L8:
			mov eax, 11
			call settextcolor
			mov al, '@';
			call WriteChar
			mov eax, 15
			call settextcolor
			jmp L6
		L9:
			mov eax, 14
			call settextcolor
			mov al, '-';
			call WriteChar
			mov eax, 15
			call settextcolor
 
			jmp L6
		L6:
		inc esi
	dec ecx
	jmp L2
	endl2:

	mov eax, 15
	call settextcolor 
	pop ecx
	dec ecx
	.if(ecx != 0)
		call crlf
	.endif
jmp L1
endl1:
	;call crlf
	mov edx ,offset str1
	call writestring
	mov eax ,score
	call writeint
	pop ecx
	pop esi
	pop edx

ret
print endp


end main