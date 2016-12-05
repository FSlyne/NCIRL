; --------------------------------------------------------------
; pico OS 01
; --------------------------------------------------------------
	JMP	Boot; Jump past table of interrupt vectors
	DB	91 ; Vector at 04 pointing to address 91
Boot:
	STI
	CLO   
Scheduler:
	CALL	51
	CALL	71
	JMP	Scheduler

; ---------------- API ----------------------------

WrTraflight: ; Function to write out Traffic Light
        ORG	10
	POP	DL ; Save return address in DL
	POP	AL
        OUT	01
	PUSH	DL ; Restore return address
        ret

WrSevenSegment: ; Function to write out Seven Segment Display
	ORG	20
	POP	DL ; Save return address in DL
	POP	AL
        OUT	02
	PUSH	DL ; Restore return address
        ret

WrVDU: ; Function to write out Seven Segment Display
	ORG	30
	POP	DL ; Save return address in DL
	POP	AL
        MOV	[C0],AL
	PUSH	DL ; Restore return address
        ret

; -------------------- Process Map ------------------------

	ORG	50
	DB	E0	; Data byte
Process_1:
	MOV	AL,[50]	; Copy bits from RAM into AL
	NOT	AL	; Invert the bits in AL
	MOV	[50],AL	; Copy inverted bits back to RAM
	PUSH	AL
        CALL	10
	RET


	ORG	70
	DB	0	; Data byte
Process_2:
	MOV	AL,[70]	; Copy bits from RAM into AL
	NOT	AL	; Invert the bits in AL
	AND	AL,FE	; Force right most bit to zero
	MOV	[70],AL	; Copy inverted bits back to RAM
	PUSH	AL
        CALL	20
	RET

	ORG	90
	DB	36	; Data byte
Process_3: 
	MOV	AL,[90]
	PUSH	AL
        CALL	30
	IRET


	END


