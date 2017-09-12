 global cellRunner
  extern resume , state , cell , WorldWidth , WorldLength

section .data
x: dd 0
y: dd 0
ans: dd 0
oldX:dd 0
tmp: dd 0
isFirstTime: dd 0

section .text

cellRunner:

    mov eax,dword[x]
    mov ebx,dword[y]
    mov dword[x], esi
    mov dword[y],edi

    push dword[y]     
    push dword[x]
    
    call cell 					;----result (age) into eax ----
    mov dword[ans],eax
    pushad
    mov ebx,dword[y]
    mov ecx,dword[x]
    jmp checkCords

  afterCordChange:
    popad
    mov ecx,dword[y]
    mov ebx,dword[x]
    dec ebx
    mov dword[oldX],ebx

    push dword[y]
    push dword[oldX]
    push dword[ans]
    mov ebx,0             ;  scheduler index
    call resume             ; resume scheduler

    pop dword[ans]
    mov ecx,dword[ans]
    mov eax,dword[ans]
    mov dword[x], esi
    mov dword[y],edi
    inc dword[isFirstTime]
   
    mov eax , [WorldWidth] 				; ----calc my indices at the array -----
    mov ebx , [y]
    imul ebx
    add eax,[x]

    add eax,state      		;---geting to the correct address in the array ---
    mov ebx,2
    add eax,ebx
    mov ebx, dword[ans]
    cmp dword[isFirstTime],1
    je skipThisTime
    cmp dword[ans],'1'
    jl deadCell

aliveCell:
    mov cl , byte[ans]
    mov byte[eax],cl
    push dword[y]
    push dword[x]
    xor ebx,ebx 
    call resume
    jmp cellRunner
    
	deadCell:
		mov ecx,'0'
		mov byte[eax],cl 
		xor ebx,ebx 
		push 1
	        push dword[y]
	        push dword[x]
		call resume
	        jmp cellRunner

	checkCords:
	 	cmp ecx,dword[WorldWidth]             ; ---- ecx =x  , ebx = y -----
	 	je endLineWidth
	 	inc ecx
        	mov dword[x],ecx
	 	jmp afterCordChange

	 endLineWidth:
	 		mov ecx,0
	 		cmp ebx,dword[WorldLength]	
	 		je endMatrix
	 		inc ebx
	 		mov dword[x],ecx
	 		mov dword[y],ebx
	 		jmp afterCordChange

	 endMatrix:
		mov eax, dword[WorldLength]
		mov ebx, dword[WorldWidth]
		dec eax
		dec ebx
		mov dword[x],ebx
		mov dword[y],eax
	 	jmp afterCordChange

skipThisTime:
    xor ebx,ebx 
    call resume
    jmp cellRunner
