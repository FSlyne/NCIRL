	CLO
START:
	MOV AL,30	;LET A=30
	MOV [A0],AL
  MOV AL,0	;FOR (B=0; B<20; B++) {
	MOV [A1],AL
LOOP:
	MOV AL,[A0]	;LET A=A+1
	INC AL
	MOV [A0],AL
	PUSH AL
	CALL 50		; PRINT A

	MOV AL,[A1]	;B++
	INC AL
	MOV [A1],AL
	CMP AL,20	;B<20
	JNZ LOOP	;}
	JMP END

PRINT:			; Function PRINT (X)
	ORG 50
	POP BL		; Store the return address
	POP AL		; Assign the Print function variable X
	MOV [C0],AL
	PUSH BL
	RET

END:
	END

	
