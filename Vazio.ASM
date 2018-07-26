;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*              MODIFICAÇÕES PARA USO COM 12F675                   *
;*                FEITAS PELO PROF. MARDSON                        *
;*                    FEVEREIRO DE 2016                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       NOME DO PROJETO                           *
;*                           CLIENTE                               *
;*         DESENVOLVIDO PELA MOSAICO ENGENHARIA E CONSULTORIA      *
;*   VERSÃO: 1.0                           DATA: 17/06/03          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     DESCRIÇÃO DO ARQUIVO                        *
;*-----------------------------------------------------------------*
;*   MODELO PARA O PIC 12F675                                      *
;*                                                                 *
;*                                                                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ARQUIVOS DE DEFINIÇÕES                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#INCLUDE <p12f675.inc>	;ARQUIVO PADRÃO MICROCHIP PARA 12F675

	__CONFIG _BODEN_OFF & _CP_OFF & _PWRTE_ON & _WDT_OFF & _MCLRE_ON & _INTRC_OSC_NOCLKOUT

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    PAGINAÇÃO DE MEMÓRIA                         *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;DEFINIÇÃO DE COMANDOS DE USUÁRIO PARA ALTERAÇÃO DA PÁGINA DE MEMÓRIA
#DEFINE	BANK0	BCF STATUS,RP0	;SETA BANK 0 DE MEMÓRIA
#DEFINE	BANK1	BSF STATUS,RP0	;SETA BANK 1 DE MAMÓRIA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         VARIÁVEIS                               *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DOS NOMES E ENDEREÇOS DE TODAS AS VARIÁVEIS UTILIZADAS 
; PELO SISTEMA

	CBLOCK	0x20	;ENDEREÇO INICIAL DA MEMÓRIA DE
					;USUÁRIO
		W_TEMP		;REGISTRADORES TEMPORÁRIOS PARA USO
		STATUS_TEMP	;JUNTO ÀS INTERRUPÇÕES
		CONT		;CONTADOR DISPLAY
		CONT2		;CONTADOR DE CONDIÇÃO PARA ENTRAR NA VARIAVEL 
		LOOP		;CONTADOR DE TEMPO
		LOOP2		;CONTADOR DE TEMPO AUXILIAR

		;NOVAS VARIÁVEIS

	ENDC			;FIM DO BLOCO DE MEMÓRIA
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                        FLAGS INTERNOS                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS FLAGS UTILIZADOS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         CONSTANTES                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODAS AS CONSTANTES UTILIZADAS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           ENTRADAS                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS PINOS QUE SERÃO UTILIZADOS COMO ENTRADA
; RECOMENDAMOS TAMBÉM COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           SAÍDAS                                *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS PINOS QUE SERÃO UTILIZADOS COMO SAÍDA
; RECOMENDAMOS TAMBÉM COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       VETOR DE RESET                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	ORG	0x00			;ENDEREÇO INICIAL DE PROCESSAMENTO
	GOTO	INICIO
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    INÍCIO DA INTERRUPÇÃO                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; ENDEREÇO DE DESVIO DAS INTERRUPÇÕES. A PRIMEIRA TAREFA É SALVAR OS
; VALORES DE "W" E "STATUS" PARA RECUPERAÇÃO FUTURA

	ORG	0x04			;ENDEREÇO INICIAL DA INTERRUPÇÃO
	MOVWF	W_TEMP		;COPIA W PARA W_TEMP
	SWAPF	STATUS,W
	MOVWF	STATUS_TEMP	;COPIA STATUS PARA STATUS_TEMP

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    ROTINA DE INTERRUPÇÃO                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; AQUI SERÁ ESCRITA AS ROTINAS DE RECONHECIMENTO E TRATAMENTO DAS
; INTERRUPÇÕES

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                 ROTINA DE SAÍDA DA INTERRUPÇÃO                  *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; OS VALORES DE "W" E "STATUS" DEVEM SER RECUPERADOS ANTES DE 
; RETORNAR DA INTERRUPÇÃO

SAI_INT
	SWAPF	STATUS_TEMP,W
	MOVWF	STATUS		;MOVE STATUS_TEMP PARA STATUS
	SWAPF	W_TEMP,F
	SWAPF	W_TEMP,W	;MOVE W_TEMP PARA W
	RETFIE

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*	            	 ROTINAS E SUBROTINAS                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; CADA ROTINA OU SUBROTINA DEVE POSSUIR A DESCRIÇÃO DE FUNCIONAMENTO
; E UM NOME COERENTE ÀS SUAS FUNÇÕES.

DELAY

	nop
	nop
	nop
	nop
	nop
	nop

	RETURN
	
DISPLAY
	
	MOVLW	.9
	SUBWF	CONT,W
	BTFSC	STATUS,Z
	GOTO	SETOITO
	MOVLW	.8
	SUBWF	CONT,W
	BTFSC	STATUS,Z
	GOTO	SETSETE
	MOVLW	.7
	SUBWF	CONT,W
	BTFSC	STATUS,Z
	GOTO	SETSEIS
	MOVLW	.6
	SUBWF	CONT,W
	BTFSC	STATUS,Z
	GOTO	SETCINCO
	MOVLW	.5
	SUBWF	CONT,W
	BTFSC	STATUS,Z
	GOTO	SETQUATRO
	MOVLW	.4
	SUBWF	CONT,W
	BTFSC	STATUS,Z
	GOTO	SETTRES
	MOVLW	.3
	SUBWF	CONT,W
	BTFSC	STATUS,Z
	GOTO	SETDOIS
	MOVLW	.2
	SUBWF	CONT,W
	BTFSC	STATUS,Z
	GOTO	SETUM
	MOVLW	.1
	SUBWF	CONT,W
	BTFSC	STATUS,Z
	GOTO	SETZERO
	GOTO	SETNOVE
	
SETNOVE
	BSF	GPIO,GP5
	BCF	GPIO,GP4
	BCF	GPIO,GP2
	BSF	GPIO,GP1
	RETURN
SETOITO
	BSF	GPIO,GP5
	BCF	GPIO,GP4
	BCF	GPIO,GP2
	BCF	GPIO,GP1
	RETURN
SETSETE
	BCF	GPIO,GP5
	BSF	GPIO,GP4
	BSF	GPIO,GP2
	BSF	GPIO,GP1
	RETURN
SETSEIS
	BCF	GPIO,GP5
	BSF	GPIO,GP4
	BSF	GPIO,GP2
	BCF	GPIO,GP1
	RETURN
SETCINCO
	BCF	GPIO,GP5
	BSF	GPIO,GP4
	BCF	GPIO,GP2
	BSF	GPIO,GP1
	RETURN
SETQUATRO
	BCF	GPIO,GP5
	BSF	GPIO,GP4
	BCF	GPIO,GP2
	BCF	GPIO,GP1
	RETURN
SETTRES
	BCF	GPIO,GP5
	BCF	GPIO,GP4
	BSF	GPIO,GP2
	BSF	GPIO,GP1
	RETURN
SETDOIS
	BCF	GPIO,GP5
	BCF	GPIO,GP4
	BSF	GPIO,GP2
	BCF	GPIO,GP1
	RETURN
SETUM
	BCF	GPIO,GP5
	BCF	GPIO,GP4
	BCF	GPIO,GP2
	BSF	GPIO,GP1
	RETURN
SETZERO
	BCF	GPIO,GP5
	BCF	GPIO,GP4
	BCF	GPIO,GP2
	BCF	GPIO,GP1
	RETURN
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIO DO PROGRAMA                          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
INICIO
	BANK1				;ALTERA PARA O BANCO 1
	MOVLW	B'00000000' ;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISIO		;COMO SAÍDAS
	CLRF	ANSEL 		;DEFINE PORTAS COMO Digital I/O
	MOVLW	B'00000100'
	MOVWF	OPTION_REG	;DEFINE OPÇÕES DE OPERAÇÃO
	MOVLW	B'00000000'
	MOVWF	INTCON		;DEFINE OPÇÕES DE INTERRUPÇÕES
	BANK0				;RETORNA PARA O BANCO
	MOVLW	B'00000111'
	MOVWF	CMCON		;DEFINE O MODO DE OPERAÇÃO DO COMPARADOR ANALÓGICO

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZAÇÃO DAS VARIÁVEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	BCF	GPIO,GP0
	BSF	GPIO,GP5
	BCF	GPIO,GP4
	BCF	GPIO,GP2
	BSF	GPIO,GP1
	MOVLW	.10
	MOVWF	CONT2
	MOVLW	.9
	MOVWF	CONT
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
MAIN

	MOVLW	.91
	MOVWF	LOOP2

DECREMENTAR2
	
	MOVLW	.254
	MOVWF	LOOP

DECREMENTAR
	
	CALL	DELAY
	DECFSZ	LOOP,F
	GOTO	DECREMENTAR
	DECFSZ	LOOP2,F
	GOTO	DECREMENTAR2
	CALL	DISPLAY
	DECF	CONT,F
	DECF	CONT2,F
	BTFSS	STATUS,Z
	GOTO	MAIN
	MOVLW	.10
	MOVWF	CONT2
	MOVLW	.9
	MOVWF	CONT
	BTFSS	GPIO, GP0
	GOTO	VERDE
	GOTO	VERMELHO

VERDE
	BSF	GPIO,GP0
	GOTO MAIN

VERMELHO
	BCF	GPIO,GP0
	GOTO MAIN
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END
