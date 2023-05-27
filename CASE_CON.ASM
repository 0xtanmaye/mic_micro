PRINTS MACRO SMSG
MOV AH, 09H
LEA DX, SMSG
INT 21H
ENDM

READS MACRO SBUFF
MOV AH, 0AH
LEA DX, SBUFF
INT 21H
ENDM

READB MACRO BBUFF
MOV AH, 01H
INT 21H
MOV BBUFF, AL
ENDM

DATA SEGMENT
str_rd_msg DB "Enter a string to convert to lowercase or UPPERCASE: $"
str_conv_type_msg DB "Convert to lowercase(l/L) or UPPERCASE(u/U)?: $"
str_conv_type_invalid_msg DB "Invalid conversion type, Enter l/L for lowercase or u/U for UPPERCASE: $" 
str_conv_done_upper_msg DB "String converted to UPPERCASE: $"
str_conv_done_lower_msg DB "String converted to lowercase: $"
again_msg DB "Would you like to convert another string?(y/n): $"
newline DB 0DH, 0AH, '$'
again DB ?
str_conv_type_buff DB ?
str_input_buff DB 50, 0, 50 DUP('$')
str_conv_buff DB 50, 0, 50 DUP('$')
DATA ENDS

CODE SEGMENT
ASSUME CS:CODE, DS:DATA
START:
        MOV AX, DATA
        MOV DS, AX

        PRINTS newline
        PRINTS str_rd_msg
        PRINTS newline
        READS str_input_buff

        PRINTS newline
        PRINTS str_conv_type_msg
        READ_CONV_TYPE:
                READB str_conv_type_buff

        LEA SI, str_input_buff+2
        LEA DI, str_conv_buff+2
        MOV AL, str_conv_type_buff
        CMP AL, 'u'
        JE UPPERCASE
        CMP AL, 'U'
        JE UPPERCASE
        CMP AL, 'l'
        JE LOWERCASE
        CMP AL, 'L'
        JE LOWERCASE
        PRINTS newline
        PRINTS str_conv_type_invalid_msg
        JMP READ_CONV_TYPE
        UPPERCASE:
                MOV AL, [SI]
                CMP AL, '$'
                JE PRINT_OUT

                CMP AL, 'a'
                JB COPY_UPPER
                CMP AL, 'z'
                JA COPY_UPPER

                SUB AL, 20H
                MOV [DI], AL
                JMP NEXT_UPPER

        COPY_UPPER:
                MOV [DI], AL

        NEXT_UPPER:
                INC SI
                INC DI
                JMP UPPERCASE

        MIDJUMP:
                JMP START

        LOWERCASE:
                MOV AL, [SI]
                CMP AL, '$'
                JE PRINT_OUT

                CMP AL, 'A'
                JB COPY_LOWER
                CMP AL, 'Z'
                JA COPY_LOWER

                ADD AL, 20H
                MOV [DI], AL
                JMP NEXT_LOWER

        COPY_LOWER:
                MOV [DI], AL

        NEXT_LOWER:
                INC SI
                INC DI
                JMP LOWERCASE

        PRINT_OUT:
                PRINTS newline
                MOV AL, str_conv_type_buff
                CMP AL, 'u'
                JE UPPERCASE_DONE
                CMP AL, 'U'
                JE UPPERCASE_DONE
                CMP AL, 'l'
                JE LOWERCASE_DONE
                CMP AL, 'L'
                JE LOWERCASE_DONE

        UPPERCASE_DONE:
                PRINTS str_conv_done_upper_msg
                JMP DONE

        LOWERCASE_DONE:
                PRINTS str_conv_done_lower_msg
                JMP DONE

        DONE:
                PRINTS newline
                PRINTS str_conv_buff+2
                PRINTS newline

                PRINTS newline
                PRINTS again_msg
                READB again
                MOV AL, again
                CMP AL, 'y'
                JE SHORT MIDJUMP
                CMP AL, 'Y'
                JE SHORT MIDJUMP

        EXIT:
                MOV AH, 4CH
                INT 21H
CODE ENDS
END START
