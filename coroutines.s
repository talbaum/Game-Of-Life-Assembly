;;; This is a simplified co-routines implementation:
;;; CORS contains just stack tops, and we always work
;;; with co-routine indexes.
        global init_co, start_co, end_co, resume


maxcors:        equ 100*100+2         ; maximum number of co-routines
stacksz:        equ 16*1024     ; per-co-routine stack size

section .bss

stacks: resb maxcors * stacksz  ; co-routine stacks
cors:   resd maxcors            ; simply an array with co-routine stack tops
curr:   resd 1                  ; current co-routine
origsp: resd 1                  ; original stack top
tmp:    resd 1                  ; temporary value


section .text
        ;; esi = i
        ;; edi = j (if im cell)
        ;; edi = t (if im scheduler)
        ;; eax = k
        ;; ebx = co-routine index to initialize
        ;; edx = co-routine start
        ;; other registers will be visible to co-routine after "start_co"
init_co:   
        push ebp
        mov ebp, esp     
        cmp ebx,0
        jne notSchedulerCheck
        push edi
        push eax
        call imScheduler
        mov esp, ebp
        pop ebp
        ret

notSchedulerCheck:
        call notScheduler
        mov esp, ebp
        pop ebp
        ret

notScheduler:
        push ebp
        mov ebp, esp 
	push esi                ;------------- push x-------------- 
        push edi                ;------------- push y---------------
        push eax                ; save eax (on callers stack)
	push edx
	mov edx,0
	mov eax,stacksz
        imul ebx			    ; eax = co-routines stack offset in stacks
        pop edx
	add eax, stacks + stacksz ; eax = top of (empty) co-routines stack
        mov [cors + ebx*4], eax ; store co-routines stack top
        pop eax                 ; restore eax (from callers stack)

        mov [tmp], esp          ; save callers stack top
        mov esp, [cors + ebx*4] ; esp = co-routines stack top

  
        push edx                ; save return address to co-routine stack
        pushf                   ; save flags
        pusha                   ; save all registers
        mov [cors + ebx*4], esp ; update co-routines stack top

        mov esp, [tmp]          ; restore callers stack top
        mov esp, ebp
        pop ebp
        ret                     ; return to caller



imScheduler:
        push ebp
        mov ebp, esp 
        push eax                ;------------- push k-------------- 
        push edi                ;------------- push t---------------
        push eax                ; save eax (on callers stack)
        push edx
        mov edx,0
        mov eax,stacksz
        imul ebx                            ; eax = co-routines stack offset in stacks
        pop edx
        add eax, stacks + stacksz ; eax = top of (empty) co-routines stack
        mov [cors + ebx*4], eax ; store co-routines stack top
        pop eax                 ; restore eax (from callers stack)

        mov [tmp], esp          ; save callers stack top
        mov esp, [cors + ebx*4] ; esp = co-routines stack top

        push edx                ; save return address to co-routine stack
        pushf                   ; save flags
        pusha                   ; save all registers
        mov [cors + ebx*4], esp ; update co-routines stack top

        mov esp, [tmp]          ; restore callers stack top
        mov esp, ebp
        pop ebp
        ret                     ; return to caller



        ;; ebx = co-routine index to start
start_co:
        pusha                   ; save all registers (restored in "end_co")
        mov [origsp], esp       ; save callers stack top
        mov [curr], ebx         ; store current co-routine index
        jmp resume.cont         ; perform state-restoring part of "resume"

        ;; can be called or jumped to
end_co:
        mov esp, [origsp]       ; restore stack top of whoever called "start_co"
        popa                    ; restore all registers
        ret                     ; return to caller of "start_co"

        ;; ebx = co-routine index to switch to
resume:                         ; "call resume" pushed return address
        pushf                   ; save flags to source co-routine stack
        pusha                   ; save all registers
        xchg ebx, [curr]        ; ebx = current co-routine index
        mov [cors + ebx*4], esp ; update current co-routines stack top
        mov ebx, [curr]         ; ebx = destination co-routine index
.cont:
        mov esp, [cors + ebx*4] ; get destination co-routines stack top
        popa                    ; restore all registers
        popf                    ; restore flags
        ret                     ; jump to saved return address
