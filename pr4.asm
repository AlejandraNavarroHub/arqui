include macros.asm

.model small
.stack 64h
.data
    msg1 db "UNIVERSIDAD DE SAN CARLOS DE GUATEMALA","$"
    msg2 db "Arquitectura de computadores y ensambladores 1","$"
    msg3 db "Evelyn Alejandra Navarro Ozorio - 201902046","$"
    msg4 db "Practica 4","$"
    msg5 db "--------------- INGRESE COMANDO ---------------", "$"
    msg6 db "Finalizado - 201902046","$"
    entrada db 100 dup('$')
    comando db 10 dup('$')
    complemento db 10 dup('$')
    ente db 0ah, "$"
    iter dw 0d
    iter2 dw 0d
    retorno db 0
    ;Los comandos disponibles
    abrir db "abrir$$$$$"
    contar db "contar$$$$"
    prop db "prop$$$$$$"
    colorear db "colorear$$"
    reporte db "reporte$$$"
    diptongo db "diptongo$$"
    hiato db "hiato$$$$$"
    triptongo db "triptongo$"



.code
main proc 
    mov ax,@data
    mov ds, ax

    print msg1
    print ente
    print msg2
    print ente
    print msg3
    print ente
    print msg4
    print ente
    print msg5
    print ente

    ;------------ INGRESO DE COMANDOS --------------
    
    LecturaTec entrada

    separarComando entrada

    print comando
    print ente
    print abrir
    print ente

    CompararCadena comando, abrir
    Imprimir8bits retorno

    mov ax,4C00H;AX = 4C00H
    INT 21H

main endp
end main