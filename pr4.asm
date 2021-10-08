include macros.asm

.model small
.stack 64h
.data
    msg1 db 0ah, 0dh,"UNIVERSIDAD DE SAN CARLOS DE GUATEMALA","$"
    msg2 db 0ah, 0dh,"Arquitectura de computadores y ensambladores 1","$"
    msg3 db 0ah, 0dh,"Evelyn Alejandra Navarro Ozorio - 201902046","$"
    msg4 db 0ah, 0dh,"Practica 4","$"
    msg5 db 0ah, 0dh,"-------- INGRESE COMANDO --------", "$"
    msg6 db 0ah, 0dh,"Finalizado - 201902046","$"
    msg7 db "Total de palabras: ","$"
    entrada db 0ah, 0dh, 100 dup('$')
    comando db 10 dup('$')
    complemento db 20 dup('$')
    ente db 0ah,0dh, '$'
    iter dw 0d
    iter2 dw 0d
    retorno db 0
    ;Los comandos disponibles
    abrir db "abrir$$$$$$"
    contar db "contar$$$$$"
    prop db "prop$$$$$$$"
    colorear db "colorear$$$"
    reporte db "reporte$$$$"
    diptongo db "diptongo$$$"
    hiato db "hiato$$$$$$"
    triptongo db "triptongo$$"
    cerrar db "X$$$$$$$$$$"

    ;Los complementos
    diptongo1 db "diptongo$$$$$$$$$$$$$"
    triptongo1 db "triptongo$$$$$$$$$$$$"
    hiato1 db "hiato$$$$$$$$$$$$$$$$"
    palabra db "palabra$$$$$$$$$$$$$$"


    ; archivos
    contenedor db 1000 dup("$")
    handle dw ?
    ruta db 10 dup("$"), 0h


    ; conteos
    resultado db 0


.code
main proc 
    mov ax,@data
    mov ds, ax

    print msg1
    print msg2
    print msg3
    print msg4

    ;------------ INGRESO DE COMANDOS --------------
    inicio:
        print msg5
        print ente
        LecturaTec entrada
        separarComando entrada
        jmp comparar
    
    comparar:
        CompararCadena comando, cerrar
        cmp retorno, 1
        jz fin

        CompararCadena comando, abrir
        cmp retorno, 1
        jz openA
        
        CompararCadena comando, contar
        cmp retorno, 1
        jz count


    fin:
        mov ax,4C00H;AX = 4C00H
        INT 21H
    
    openA:
        mov complemento[20], 0h 
        OpenFile complemento,handle
        ReadFile handle,contenedor,1000   
        mov complemento[20], "$"
        print ente
        print contenedor
        print ente
        jmp inicio
    
    count:
        CompararCadena complemento, palabra
        cmp retorno, 1
        jz CPal
    
    CPal:
        ContarPalabras contenedor
        print ente
        print msg7
        Imprimir8bits resultado
        print ente
        jmp inicio


main endp
end main
