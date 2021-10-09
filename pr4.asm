include macros.asm

.model small
.stack 64h
.data

    msg30 db 0ah, 0dh,"envio a analizar:  ","$"
    espacio db 1 dup('$') 

    msg0 db 0ah, 0dh,"Comando incorrecto","$"
    msg1 db 0ah, 0dh,"UNIVERSIDAD DE SAN CARLOS DE GUATEMALA","$"
    msg2 db 0ah, 0dh,"Arquitectura de computadores y ensambladores 1","$"
    msg3 db 0ah, 0dh,"Evelyn Alejandra Navarro Ozorio - 201902046","$"
    msg4 db 0ah, 0dh,"Practica 4","$"
    msg5 db 0ah, 0dh,"-------- INGRESE COMANDO --------", "$"
    msg6 db 0ah, 0dh,"Finalizado - 201902046","$"
    msg7 db "Total de palabras: ","$"
    msg8 db 0ah, 0dh,"Total de diptongos: ","$"
    msg9 db 0ah, 0dh,"Total de triptongos: ","$"
    msg10 db 0ah, 0dh,"Total de hiatos: ","$"
    msg11 db 0ah, 0dh,"%prop: ","$"
    msg12 db 0ah, 0dh,"La palabra - ","$"
    msg13 db " - no contiene ","$"
    msg14 db " diptongo.","$"
    msg15 db " hiato.","$"
    msg16 db " triptongo.","$"
    msg17 db " - contiene diptongo tipo: ","$"
    msg18 db " creciente.","$"
    msg19 db " decreciente.","$"
    msg20 db " homogeneo.","$"
    msg21 db " - contiene ","$"
    entrada db 100 dup('$')
    comando db 10 dup('$')
    complemento db 20 dup('$')
    ente db 0ah, '$'
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
    pala db 0
    resultado db 0
    trip db 0
    hia db 0
    ini db 0
    fi db 0
    palabraC db 20 dup("$")
    llenado dw 0d
    med db 0

    ; validar
    tipo db 0
    col db 0
    

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
        LlenarVariable complemento, 20
        LlenarVariable comando, 10
        mov retorno, 0
        LecturaTec entrada
        separarComando entrada
        jmp comparar
    
    comparar:
        limpiar
        CompararCadena comando, cerrar
        cmp retorno, 1
        jz fin

        CompararCadena comando, abrir
        cmp retorno, 1
        jz openA
        
        CompararCadena comando, contar
        cmp retorno, 1
        jz count

        CompararCadena comando, prop
        cmp retorno, 1
        jz PProp
        
        CompararCadena comando, diptongo
        cmp retorno, 1
        jz DipPa

        CompararCadena comando, triptongo
        cmp retorno, 1
        jz TripPa

        CompararCadena comando, hiato
        cmp retorno, 1
        jz HiaPa
        jnz Er


    fin:
        mov ax,4C00H;AX = 4C00H
        INT 21H
    
    openA:
        mov complemento[20], 0h 
        OpenFile complemento,handle
        ReadFile handle,contenedor,1000   
        LlenarVariable complemento, 20
        print ente
        jmp inicio
    
    count:
        limpiar
        CompararCadena complemento, palabra
        cmp retorno, 1
        jz CPal

        CompararCadena complemento, diptongo1
        cmp retorno, 1
        jz CDip

        CompararCadena complemento, triptongo1
        cmp retorno, 1
        jz CTrip

        CompararCadena complemento, hiato1
        cmp retorno, 1
        jz CHia
        jnz Er
    
    CPal:
        limpiar
        ContarPalabras contenedor
        print ente
        print msg7
        Imprimir8bits pala
        print ente
        jmp inicio

    CDip:
        limpiar
        ContarTriptongo contenedor
        print ente
        print msg8
        Imprimir8bits resultado
        print ente
        jmp inicio

    CTrip:
        limpiar
        ContarTriptongo contenedor
        print msg9
        Imprimir8bits trip
        print ente
        jmp inicio

    CHia:
        limpiar
        ContarTriptongo contenedor
        print msg10
        Imprimir8bits hia
        print ente
        jmp inicio

    PProp:
        limpiar
        CompararCadena complemento, diptongo1
        cmp retorno, 1
        jz DDip

        CompararCadena complemento, triptongo1
        cmp retorno, 1
        jz DTrip

        CompararCadena complemento, hiato1
        cmp retorno, 1
        jz DHia
        jnz Er

    DDip:
        limpiar
        ContarPalabras contenedor
        ContarTriptongo contenedor
        media resultado, pala
        print msg11
        Imprimir8bits med
        print ente
        jmp inicio

    DTrip:
        limpiar
        ContarPalabras contenedor
        ContarTriptongo contenedor
        media trip, pala
        print msg11
        Imprimir8bits med
        print ente
        jmp inicio


    DHia:
        limpiar
        ContarPalabras contenedor
        ContarTriptongo contenedor
        media hia, pala
        print msg11
        Imprimir8bits med
        print ente
        jmp inicio
    
    DipPa:
        limpiar
        BuscarTriptongo complemento
        cmp resultado, 0
        jz ImpDip
        jnz ImpDN

    TripPa:
        limpiar
        BuscarTriptongo complemento
        cmp trip, 0
        jz ImpTrip
        jnz ImpTN

    HiaPa: 
        limpiar
        BuscarTriptongo complemento
        cmp hia, 0
        jz ImpHia
        jnz ImpHN

    ImpDip:
        print msg12
        print complemento
        print msg13
        print msg14
        print ente
        jmp inicio

    ImpDN:
        print msg12
        print complemento
        print msg17
        jmp tipado
    

    ImpTrip:
        print msg12
        print complemento
        print msg13
        print msg16
        print ente
        jmp inicio

    ImpTN:
        print msg12
        print complemento
        print msg21
        print msg16
        print ente
        jmp inicio

    ImpHia:
        print msg12
        print complemento
        print msg13
        print msg15
        print ente
        jmp inicio
    
    ImpHN:
        print msg12
        print complemento
        print msg21
        print msg15
        print ente
        jmp inicio
    
    Er:
        print msg0
        print ente
        jmp inicio
    
    tipado:
        cmp tipo, 1
        jz tip
        cmp tipo, 2
        jz tip2
        jnz tip3
    tip:
        print msg18
        print ente
        jmp inicio
    tip2:
        print msg19
        print ente
        jmp inicio
    tip3:
        print msg20
        print ente
        jmp inicio
    
main endp
end main
