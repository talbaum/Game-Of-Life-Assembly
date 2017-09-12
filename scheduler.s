         global scheduler
        extern resume, end_co, cell, WorldWidth,WorldLength

section .data
    row dd 0
    column dd 0
    genNum dd 0
    modulo dd 0
    T dd 0
    K dd 0
    printCount: dd 0
    MatrixIterator: dd 2
	matSz: dd 0

section .text
scheduler:
        add edi,edi
        mov dword[T], edi
        mov dword[K],eax
		pushad
		mov eax, dword[WorldLength]
        mov ebx, dword[WorldWidth]
        mul ebx	
		inc eax
        mov dword[matSz], eax
		popad
                                       
next:
        mov edi,dword[matSz]
        cmp dword [MatrixIterator],edi
        jg changeGenNum
        
        mov edi,dword[K]
        cmp dword[printCount],edi
        je printerTime
        jne cellTime
        

   printerTime:
             mov dword[printCount],0
             mov ebx,1
             call resume     
             jmp next

    cellTime:
            inc dword[printCount]
            mov ebx,dword[MatrixIterator]
            call resume
            inc dword[MatrixIterator] 
            jmp checkColAndRow


checkColAndRow:
        mov eax,dword[WorldWidth]
        cmp dword[column],eax
        je changeRow
        inc dword[column]
        jmp next

changeRow:
        mov dword[column],0
        mov eax,dword[WorldLength]
        cmp dword[row],eax
        je changeGenNum
        inc dword[row]
        jmp next


changeGenNum:   
    mov dword[row],0
    inc dword[genNum]
    mov dword[MatrixIterator],2
    mov edi,dword[T]
    cmp dword[genNum],edi
    jge endProgram
    jmp next


endProgram:
        mov ebx,1
        call resume             ; call printer 
        mov ebx,1
        call resume
        call end_co             ; stop co-routines
