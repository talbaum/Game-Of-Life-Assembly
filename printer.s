        global printer
        extern state , WorldWidth,WorldLength, system_call
        extern resume

        ;; /usr/include/asm/unistd_32.h
sys_write:      equ   4
stdout:         equ   1

section .bss
	statePrint:  resb (100 * 100 + 2 ) *2   ; need to check this 
	sizeOfState: resb 100* 100 +2

section .data
MatrixSize: dd 0
slashNCount: dd 0
nextLine:
        db "" , 10 ,0 



section .text

printer:
	mov ecx, state
	mov eax, 2
 	add ecx, eax  
    mov edi, statePrint
    mov esi, 0

    calcMatrixSize:
    		pushad
			mov eax, dword[WorldLength]
	        mov ebx, dword[WorldWidth]
	        mul ebx
	        mov dword[MatrixSize], eax
	        popad

    zeroLoop2:
   		 mov eax,dword[MatrixSize]
        cmp esi, dword[MatrixSize]
        je doneCopy2
        
	afterDiv:
        inc dword[slashNCount]
		mov eax, dword[WorldWidth]
		cmp dword[slashNCount] ,eax
		je sleshEn2
		jne revah2	

        revah2:
        	mov dl, byte[ecx]
        	call putNum
            mov ebx , edi
            mov eax, 1
            add ebx, eax    
            mov edi, ebx
           ; mov byte[edi], ' '
            ;mov ebx , edi
            ;mov eax, 1
           ; add ebx, eax
            ;mov edi, ebx
            inc esi
 			
 			mov eax, 1
            add ecx, eax       
                 
            jmp zeroLoop2
   
            
        sleshEn2:
            mov dword[slashNCount],0
        	mov dl, byte[ecx]
        	call putNum
            mov ebx , edi
            mov eax, 1
            add ebx, eax    
            mov edi, ebx
           
           ; mov byte[edi], ' '           ;	we put space at the end of every line. maybe change it
           ; mov ebx , edi
          ;  mov eax, 1
           ; add ebx, eax
           ; mov edi, ebx

            mov byte[edi], 10
            mov ebx , edi
            mov eax, 1
            add ebx, eax
            mov edi, ebx
            inc esi
 			
 			mov eax, 1
            add ecx, eax       
                 
            jmp zeroLoop2
   
            
   doneCopy2:
        mov eax, sys_write
        mov ebx, stdout
        mov ecx, statePrint
        mov edx, dword[MatrixSize]
        add edx,dword[WorldLength]
        add edx,dword[WorldLength]
        int 80h

 		;push  1
        ;push nextLine
        ;push  1
        ;push  4
        ;CALL system_call

        xor ebx, ebx
        call resume             ; resume scheduler

        jmp printer





        ;------------------------------------------------------------ functions & macros -----------------------------------------------------------------------;
 putNum :      
    
		push ebp
        mov ebp, esp   

        cmp dl, '0' 
        je zero
        cmp dl, '1' 
        je one
        cmp dl, '2' 
        je two
        cmp dl, '3' 
        je three
        cmp dl, '4' 
        je four
        cmp dl, '5' 
        je five
        cmp dl, '6' 
        je six
        cmp dl, '7' 
        je seven
        cmp dl, '8' 
        je eight
        cmp dl, '9' 
        je nine
    
        jmp goDown
      
        
        zero:
            mov byte[edi], '0'	 
            jmp finishedAssignment 
        one:
            mov byte[edi], '1'
            jmp finishedAssignment
        two:
            mov byte[edi], '2'
            jmp finishedAssignment	  
        three:
            mov byte[edi], '3'
            jmp finishedAssignment
        four:
            mov byte[edi], '4'	
            jmp finishedAssignment  
        five:
            mov byte[edi], '5'
            jmp finishedAssignment
        six:
            mov byte[edi], '6'	  
            jmp finishedAssignment
        seven:
            mov byte[edi], '7'
            jmp finishedAssignment
        eight:
            mov byte[edi], '8'	
            jmp finishedAssignment  
        nine:
            mov byte[edi], '9'
            jmp finishedAssignment  
        goDown:
            mov byte[edi], 10

        finishedAssignment:    
   		    mov esp, ebp
            pop ebp
            ret
    
;-----------------------------------------------------------------------------------------------------------------------------------------------------;
global state