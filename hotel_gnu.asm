; ===================================================
; PROJECT: https://riyachavan935-ai.github.io/Student-/
; TITLE: Smart Hotel Table Allocator - GNU SIM 8085
; MAPPING: CALL=Book Table, PUSH=Order, SP=Cart, HLT=Order
; STUDENT: Riya Chavan
; ===================================================

; --- MEMORY INIT - 6 Tables at 2000H ---
        LXI H, 2000H
        MVI M, 00H ; T01 FREE
        INX H
        MVI M, 01H ; T02 BOOKED
        INX H
        MVI M, 00H ; T03 FREE - Isko book karenge
        INX H
        MVI M, 00H ; T04 FREE
        INX H
        MVI M, 01H ; T05 BOOKED
        INX H
        MVI M, 00H ; T06 FREE

        LXI SP, 2110H ; Food Stack ke liye
        LXI B, 0000H ; C = SP Count (Cart Items)
        LXI D, 0000H ; DE = Bill = 0

; ---------- BOOK TABLE - CALL Operation ----------
BOOK: MVI A, 02H ; Select T03 (ID 2)
        STA 2050H ; HL Register Memory

        LXI H, 2000H
        ADD L ; HL = 2000H + 02 = 2002H (T03)
        MOV L, A
        MOV A, M
        CPI 01H
        JZ BOOK_FAIL ; Agar 01H hai toh already booked

        MVI M, 01H ; BOOK KARO - 01H mark karo
        MVI A, 01H
        STA 2301H ; Z=1 Success
        JMP ORDER

BOOK_FAIL:
        MVI A, 00H
        STA 2301H ; Z=0 Fail
        HLT

; ---------- FOOD ORDER - PUSH Operation ----------
ORDER: ; 1. Burger - Rs 150
        MVI A, 01H ; Food Code 01H
        PUSH B ; PUSH to Stack
        INR C ; SP++
        MOV A, C
        STA 2300H ; SP Count save karo

        LXI H, 2200H ; Bill memory
        MOV A, M
        ADI 96H ; 96H = 150 Decimal
        MOV M, A

        ; 2. Pizza - Rs 350
        MVI A, 02H
        PUSH B
        INR C
        MOV A, C
        STA 2300H

        LXI H, 2200H
        MOV A, M
        ADI 5EH ; 350 ka low byte
        MOV M, A
        INX H
        MOV A, M
        ADI 01H ; High byte
        MOV M, A

        ; 3. Cola - Rs 50
        MVI A, 03H
        PUSH B
        INR C
        MOV A, C
        STA 2300H

        LXI H, 2200H
        MOV A, M
        ADI 32H ; 32H = 50
        MOV M, A

        HLT

; AFTER RUN CHECK:
; 2000H : 00 01 01 00 01 00 (T03 now 01 Booked)
; 2050H : 02 (HL = T03)
; 2300H : 03 (SP = 3 Orders)
; 2301H : 01 (Z=1 Success)
; 2200H : 26 02 = 0226H = 550 Rs (150+350+50)
