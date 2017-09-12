    global _start
    global system_call
    global state      
    global cors    
    global WorldLength 
    global WorldWidth
    global MatrixSize
        extern init_co, start_co, resume
        extern scheduler, printer ,cell
        extern cellRunner

        ;; /usr/include/asm/unistd_32.h
sys_exit:       equ   1
sys_lseek:      equ   19
sys_write:      equ   4
stdout:         equ   1

section .data
    
    ; --------------------------------------------- vars -------------------------------------------------- ;
        debug dd 0
        fileNameIterator dd 0
        TIterator dd 0
        KIterator dd 0
        counter dd 0
        i dd 0
        j dd 0
        check dd 0
        lastCharWasSpace db 0
        inputIterator dd 0
        MatrixSize dd 0
        ten: dd 10
		lenOfLength dd 0
		lenOfWidth dd 0
		lenOfT dd 0
		lenOfK dd 0
		firstCell dd 0
        ; ------------------------------------------ Debug Strings ------------------------------------------------ ;
    debug_length_string:
        db "length="     

    debug_width_string:
        db "width="    

    debug_T_string:
        db "number of generations="     
    debug_K_string:
        db "print frequency="     
	debug_dRow_string:
        db "" , 10 ,0   
    ; --------------------------------------------- macros ----------------------------------------------- ;   
    
  %macro printinputMatrix 0       ;https://www.tutorialspoint.com/assembly_programming/assembly_file_management.htm;
    
  
;mov esi,FileName
   mov eax, 5
   mov ebx, [hexaNameBuffer]
   mov ecx, 0             ;for read only access
   mov edx, 0777          ;read, write and execute by all
   int  0x80
    
   mov  [fd_in], eax
    
   ;read from file
   mov eax, 3
   mov ebx, [fd_in]
   mov ecx, info
   mov edx, 10002
   int 0x80

    mov ecx, info
    mov edi, infoPrint
    mov ebx, state
    mov eax, 2           ;increase state iterator - we made space for schueduler printer
    add ebx, eax
    mov esi, 0
    zeroLoop:
        
        cmp esi, dword[MatrixSize]
        je doneCopy
        
        mov dl ,byte[ecx]
        cmp dl, ' ' 
        je revah
        mov dl ,byte[ecx]
        cmp dl, 10
        jne one
        je sleshEn
        
        revah:
            mov eax, 1           ;increase info iterator
            add ecx, eax  

            mov byte[ebx], '0'   ;for state
            mov eax, 1           ;increase state iterator
            add ebx, eax

            mov byte[edi], '0'	  
            push ebx
            mov ebx , edi
            mov eax, 1
            add ebx, eax    ;increase info print iterator
            mov edi, ebx
           ; mov byte[edi], ' '
            ;mov ebx , edi
           ; mov eax, 1
           ; add ebx, eax
           ; mov edi, ebx
            pop ebx
            inc esi
            jmp zeroLoop
   
        one:
            mov eax, 1
            add ecx, eax

 			mov byte[ebx], '1'   ;for state
            mov eax, 1           ;increase state iterator
            add ebx, eax

            push ebx
            mov byte[edi], '1'
            mov ebx , edi
            mov eax, 1
            add ebx, eax    
            mov edi, ebx
            ;mov byte[edi], ' '
            ;mov ebx , edi
           ; mov eax, 1
           ; add ebx, eax    
           ; mov edi, ebx
            pop ebx            
            inc esi
            jmp zeroLoop
            
        sleshEn:
            mov eax, 1
            add ecx, eax
            mov byte[edi], 10
            push ebx
            mov ebx , edi
            mov eax, 1
            add ebx, eax    
            mov edi, ebx
            pop ebx
            jmp zeroLoop
            
   doneCopy:
   ; close the file
   mov byte[ebx], 10
   mov eax, 6
   mov ebx, [fd_in]
   int 0x80
    
   ; print the info 
   mov eax, 4
   mov ebx, 1
   mov ecx, infoPrint
   
   mov edx, dword[MatrixSize]
   add edx, dword[WorldLength]
   int 0x80

   newLine
   newLine
    %endmacro
    

 %macro newLine 0 
        push  1
        push debug_dRow_string
        push  stdout
        push  sys_write
        CALL system_call
		

     popad
%endmacro
    
 
     %macro printDebug 0
     print_Debug_Length:
     pushad

        push 7      
        push debug_length_string
        push stdout
        push sys_write      
        CALL system_call
            
        mov esi,  dword[LengthAsString]
        push  dword[lenOfLength]
        push esi
        push  stdout
        push  sys_write
        CALL system_call
    
        newLine

    print_Debug_Width:
     pushad
        push 6
        push debug_width_string
        push stdout
        push sys_write      
        CALL system_call
        
        mov esi,   dword[WidthAsString]
        push  dword[lenOfWidth]
        push esi
        push  stdout
        push  sys_write
        CALL system_call
            
        newLine 
    print_Debug_T:
     pushad
        push 22
        push debug_T_string
        push stdout
        push sys_write      
        CALL system_call
        
        mov esi,  dword[TAsString]
        push  dword[lenOfT]
        push esi
        push  stdout
        push  sys_write
        CALL system_call
        
        newLine 
    print_Debug_K:
     pushad
        ;mov esi, dword[K]
        ;push esi
        push 16
        push debug_K_string
        push stdout
        push sys_write      
        CALL system_call
        
        
        mov esi,  dword[KAsString]
        push  dword[lenOfK]
        push esi
        push  stdout
        push  sys_write
        CALL system_call
        
        newLine

     print_Debug_inputMatrix:
     pushad
         printinputMatrix
		 newLine
     popad
    %endmacro
    
    
    
    %macro args6 0
    check1:
        mov edi, dword [esp + 4 * 2]                            ; fileName
        mov dword[hexaNameBuffer],edi


        mov edi, dword [esp + 4 * 3]                            ; length
        push edi
        call atoi
        add esp,4
		
        mov dword[WorldLength], eax

  
        xor eax,eax
        xor edi,edi

        mov edi, dword [esp + 4 * 4]                        ; width
        push edi
        call atoi
        add esp,4
        mov dword[WorldWidth],eax
        xor eax,eax
    
            
        mov     edi, dword [esp + 4 * 5]                    ; t
        push edi
        call atoi
        add esp,4
        mov dword[T], eax
     
        xor eax,eax
        xor edi,edi

        mov     edi, dword [esp + 4 * 6]                    ; k
        push edi
        call atoi
        add esp,4
        mov dword[K], eax
        xor eax,eax
        xor edi,edi
      

    %endmacro
    
	
	
	%macro matrixToState 0
	    
            pushad
          
;mov esi,FileName
   mov eax, 5
   mov ebx, [hexaNameBuffer]
   mov ecx, 0             ;for read only access
   mov edx, 0777          ;read, write and execute by all
   int  0x80
    
   mov  [fd_in], eax
    
   ;read from file
   mov eax, 3
   mov ebx, [fd_in]
   mov ecx, info
   mov edx, 10002
   int 0x80

    mov ecx, info
    mov ebx, state
    mov eax, 2           ;increase state iterator - we made space for schueduler printer
    add ebx, eax
    mov esi, 0
    zeroLoop1:
        
		
        cmp esi, dword[MatrixSize]
        je doneCopy1
        
        mov dl ,byte[ecx]
        cmp dl, ' ' 
        je revah1
        mov dl ,byte[ecx]
        cmp dl, 10
        jne one1
        je sleshEn1
        
        revah1:
            mov eax, 1           ;increase info iterator
            add ecx, eax  
            mov byte[ebx], '0'   ;for state
            mov eax, 1           ;increase state iterator
            add ebx, eax
            inc esi
            jmp zeroLoop1
   
        one1:
            mov eax, 1
            add ecx, eax
 			mov byte[ebx], '1'   ;for state
            mov eax, 1           ;increase state iterator
            add ebx, eax                 
            inc esi
            jmp zeroLoop1
            
        sleshEn1:
            mov eax, 1
            add ecx, eax         
            jmp zeroLoop1
            
   doneCopy1:
   ; close the file
   mov byte[ebx], 10
   mov eax, 6
   mov ebx, [fd_in]
   int 0x80
	   popad
	   
	   
	
  %endmacro	
	
	
	
	
	
	
    %macro args7 0
        mov dword[debug],1
        mov edi, dword [esp + 4 * 3]                            ; fileName
        mov dword[hexaNameBuffer],edi

	
        mov edi, dword [esp + 4 * 4]                            ; length
		mov dword[LengthAsString], edi
        push edi
        call atoi
        add esp,4
		
        mov dword[WorldLength], eax
        xor eax,eax
        xor edi,edi


        mov edi, dword [esp + 4 * 5]                        ; width
		mov dword[WidthAsString], edi
        push edi
        call atoi
        add esp,4
        mov dword[WorldWidth],eax
        xor eax,eax
		xor edi,edi
            
        mov     edi, dword [esp + 4 * 6]                    ; t
		mov dword[TAsString], edi
        push edi
        call atoi
        add esp,4
        mov dword[T], eax
        xor eax,eax
        xor edi,edi

        mov     edi, dword [esp + 4 * 7]                    ; k
		mov dword[KAsString], edi
        push edi
        call atoi
        add esp,4
        mov dword[K], eax
        xor eax,eax
        xor edi,edi
        
		push dword[LengthAsString]
		call _mystrlen
		add esp,4
	
		mov dword[lenOfLength], eax 

		push dword[WidthAsString]
		call _mystrlen
		add esp,4
	
		mov dword[lenOfWidth], eax 		
		
		
		push dword[TAsString]
		call _mystrlen
		add esp,4
	
		mov dword[lenOfT], eax 
		
		push dword[KAsString]
		call _mystrlen
		add esp,4
	
		mov dword[lenOfK], eax 
		
    %endmacro

    
        ; --------------------------------------------- functions ----------------------------------------------- ;
    system_call:
    push    ebp             ; Save caller state
    mov     ebp, esp
    sub     esp, 4          ; Leave space for local var on stack
    pushad                  ; Save some more caller state

    mov     eax, [ebp+8]    ; Copy function args to registers: leftmost...        
    mov     ebx, [ebp+12]   ; Next argument...
    mov     ecx, [ebp+16]   ; Next argument...
    mov     edx, [ebp+20]   ; Next argument...
    int     0x80            ; Transfer control to operating system
    mov     [ebp-4], eax    ; Save returned value...
    popad                   ; Restore caller state (registers)
    mov     eax, [ebp-4]    ; place returned value where caller can see it
    add     esp, 4          ; Restore caller state
    pop     ebp             ; Restore caller state
    ret                     ; Back to caller

atoi:
        push    ebp
        mov     ebp, esp        ; Entry code - set up ebp and esp
        push ecx
        push edx
        push ebx
        mov ecx, dword [ebp+8]  ; Get argument (pointer to string)
        xor eax,eax
        xor ebx,ebx
atoi_loop:
        xor edx,edx
        cmp byte[ecx],0
        jz  atoi_end
        imul dword[ten]
        mov bl,byte[ecx]
        sub bl,'0'
        add eax,ebx
        inc ecx
        jmp atoi_loop
atoi_end:
        pop ebx                 ; Restore registers
        pop edx
        pop ecx
        mov     esp, ebp        ; Function exit code
        pop     ebp
        ret


_mystrlen:
 
    push ebp
    mov ebp, esp

    mov edx, [ebp+8]    ; the string
    xor eax, eax        ; loop counter

    jmp if

then:
    inc eax

if:
    mov cl, [edx+eax]
    cmp cl, 0x0
    jne then

end:
    pop ebp
    ret

section .bss    
    infoPrint:   resb 10002 
    state:   resb 10002          ; the global array we need to intiliaze
    WorldLength  resd 3
    WorldWidth  resd 3
    FileName: resb 256
    fd_in  resb 1
    output: resb 256
    info resb  10002 
    T resd 256
    K resd 256
	LengthAsString  resd 3
    WidthAsString  resd 3
    TAsString resd 256
    KAsString resd 256
	
    Space resd 256
    hexaNameBuffer: resb 256 
    hexaTBuffer: resb 256
    hexaKBuffer: resb 256
    hexaLengthBuffer: resb 256
    hexaWidthBuffer:resb 256

    cors:   resd 100 * 100 + 2

   ; --------------------------------------------- end of functions ----------------------------------------------- ;
section .text
 align 16 

        ; --------------------------------------------- main ----------------------------------------------- ;

_start: 
        mov ebx, dword[esp]
        cmp ebx,6
        je args6Start
        cmp ebx,7   
        jne bad_input

    args7Start:
        args7
		pushad
		mov eax, dword[WorldLength]
        mov ebx, dword[WorldWidth]
        mul ebx
	
        mov dword[MatrixSize], eax
       popad
       printDebug
        jmp codeStart
        
    args6Start:
	args6
	pushad
		mov eax, dword[WorldLength]
        mov ebx, dword[WorldWidth]
        mul ebx
	hi:
        mov dword[MatrixSize], eax
       popad
	   matrixToState
            
 
        
    codeStart:
        enter 0, 0

        xor ebx, ebx            ; scheduler is co-routine 0
        mov edx, scheduler
        mov ecx, [ebp + 4]      ; ecx = argc
        mov eax, dword[K]
        mov edi, dword[T]
       call init_co            ; initialize scheduler state

        inc ebx                 ; printer i co-routine 1
        xor esi,esi
        xor edi,edi
        mov edx, printer
        call init_co            ; initialize printer state

	mov dword[counter],0
	mov dword[i],0
	mov dword[j],0

	cellInit:  
		mov eax, dword[MatrixSize]
		;dec eax
		mov ebx, dword[counter]
		cmp dword[counter],eax
		je finishedInit
		jmp calcCord

	endOfCalcIJ:
		mov ebx, dword[counter]				; ebx store the index of the co routine.
		inc ebx 							; we have the printer and scheduler , so each cell is at index counter+2 at the co routines indexes
		inc ebx
        mov esi, dword[i]
        mov edi, dword[j]
		
		romil:
		mov edx, cellRunner 						; edx store the function of the coroutine.
		call init_co
		inc dword[counter]
		jmp cellInit

finishedInit:
        xor ebx, ebx            ; starting co-routine = scheduler
      	call start_co           ; start co-routines


        ;; exit
        mov eax, sys_exit
        xor ebx, ebx
        int 80h
		

		firstinitial:
			mov dword[firstCell],1
			jmp endOfCalcIJ
			
calcCord:
	mov ebx, dword[firstCell]
	cmp ebx, 0
	je firstinitial
	mov ebx, dword[WorldWidth]
	dec ebx
	cmp dword[i],ebx
	je endOfLine
	mov esi, dword[i]
	mov edi, dword[j]
	inc dword[i]
	jmp endOfCalcIJ

 endOfLine:
 	mov esi,dword[i]
 	mov edi,dword[j]
 	mov dword[i],0
 	inc dword[j]
 	jmp endOfCalcIJ

	

	bad_input:
    