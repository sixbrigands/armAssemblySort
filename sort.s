;R0 contains array
;R1 contains size of array    
;R2 for first element
;R3 for second element
;R4 for upper bound of index
;R5 for outer index DID NOT WORK, MOV R5, #0 <--THIS BROKE IT
;R7 for outer index   
;R6 for inner index  
;STM R0, {R7, R6, R4, R3, R2, R1} An excellent command for debugging
  
    AREA sort_func, CODE, READONLY
    EXPORT sort


sort
    PUSH {R2, R3, R4, R6, R7, LR} ; Save some registers, and LR
    MOV R6, #0                    ; init inner index
    MOV R7, #0                    ; init outer index

    MOV R4, R1                    ; Load R4 with size(of the array) variable
    SUB R4, R4, #2                ; Subtract 2 from size to prevent exceeding array

    B loop                        ; start looping!
    

loop                              ; Iterates over the array, compares adjacent elements, swaps when necessary
    LDR R2, [R0, R6, LSL #2]      ; Set R2 as the first element (uses LSL to move 4 bits away to get element)
    ADD R6, R6, #1                ; advance index one spot so we can get next element
    LDR R3, [R0, R6, LSL #2]      ; Set R3 as the next number
    CMP R2, R3                    ; Compare the 2 elements

    ITTTE GT                      ; If statement where the 2 lines below happen if R2 > R3
    STRGT R2, [R0, R6, LSL #2]    ; store first element(R2) in second spot
    SUBGT R6, R6, #1              ; decrement index (undo line 28)
    STRGT R3, [R0, R6, LSL #2]    ; store second element(R3) in first spot
    SUBLE R6, R6, #1              ; decrement index (undo line 28, must do here to cover both if and else)
    
    ADD R6, R6, #1                ; increment inner index
    CMP R6, R4                    ; check if we've gone through the whole array
    
    IT LE                         ; if R6<=R4, loop again (not through whole array)
    BLE loop 
    
    BL my_leds                    ; display outer index on leds
    ADD R7, R7, #1                ; increment outer index(R7)
    
    CMP R7, R4                    ; check if we're done looping
    ITT LE                        ; If R7<=R4, reset inner index(R6) and start loop again 
    MOVLE R6, #0                  
    BLE loop 
    
    POP {R2, R3, R4, R6, R7, LR}  ; Restore registers, including LR
    BX LR                         ; Return to C
    

my_leds
    PUSH {R0, R1, R2, R3, R4, R5}
     
    LDR R1, =0x2009C020           ; load FIODIR into R1
    MOV R2, #0xB40000             ; Move the "All LED bits to 1" value into 2    
    STR R2, [R1,#0x1C]            ; turn off LED's
    
    MOV R2, #0x00040000           ; move a mask into R2 with 1 on the first LED bit
    AND R5, R7, #0x0000000F       ; clear input except for the last 4 digits and put in R5, don't mess with R7!!!!  
    LSL R5, R5, #18               ; shift first bit of input into position
    AND R3, R5, R2                ; put the first LED value in R3
    
    MOV R2, #0x00300000           ; move a mask into R2 with 1 on the second and third LED bit
    LSL R5, R5, #1                ; shift the second and third bit of input into position
    AND R4, R5, R2                ; put the second and third LED value in R4
    
    ORR R3, R3, R4                ; Combine R3 and R4 into R3
    MOV R4, #0x00000000           ; Clear R4
    
    MOV R2, #0x00800000           ; move a mask into R2 with 1 on the fourth LED bit
    LSL R5, R5, #1                ; shift the fourth bit of input into position
    AND R4, R5, R2                ; put the fourth LED value in R4
    
    ORR R3, R3, R4                ; Combine R3 and R4 into R3
    STR R3, [R1,#0x18]            ; turn on certain LED's
    
    LDR R1, =9999999              ; set up some regs for the wait subroutine
    MOV R2, #0
    MOV R3, #0
    B wait
    
wait                              ; a stalling functon
    ADD R2, R2, #1
    CMP R2, R1
    IT GT
    ADDGT R3, R3, #1
    CMP R3, R1
    IT LT
    BLT wait
    
    POP {R0, R1, R2, R3, R4, R5}
    BX LR
    

    ALIGN                         ; we have to put this at the end or compiler will complain
    END 
