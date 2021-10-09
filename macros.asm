print macro Texto
    push ax
    push dx
        mov ax, @data
        mov ds,ax
        mov ah,09h ;Numero de funcion para imprimir buffer en pantalla
        mov dx,offset Texto ;equivalente a que lea dx,buffer, inicializa en dx la posicion donde comienza la cadena
        int 21h
    pop dx
    pop ax
endm

printC MACRO char
    push ax
    push dx
        mov ah, 02h
        mov dl, char
        int 21h
    pop dx
    pop ax
ENDM

OpenFile macro buffer,handler
    local erro,fini
    mov AX,@data
    mov DS,AX
    mov ah,3dh
    mov al,02h
    lea dx,buffer
    int 21h
    ;jc Erro ; db con mensaje que debe existir en doc maestro
    mov handler,ax
    mov ax,0
    ;jmp fini
    erro:
    ;Print TItuloErrorArchivo
    mov ax,1
    fini:
endm
;============== MACRO CERRAR ARCHIVO==============
CloseFile macro handler
;mov checkopenfile,1
    mov AX,@data
    mov DS,AX
    mov ah,3eh
    mov bx,handler
    int 21h
    ;jc Error2 ; db con mensaje que debe existir en doc maestro
endm

;=========== MACRO LEER ARCHIVO===========
ReadFile macro handler,buffer,numbytes
    mov AX,@data
    mov DS,AX
    mov ah,3fh
    mov bx,handler
    mov cx,numbytes ; numero maximo de bytes a leer(para proyectos hacerlo gigante) 
    lea dx,buffer
    int 21h
;jc Error4 ; db con mensaje que debe existir en doc maestro
endm

LecturaTec macro entrada
    local salto, finalM, otroCiclo
    push bx
    xor bx,bx
    otroCiclo:
    mov entrada[bx],"$"
    inc bx
    cmp bx, 100
    jnz otroCiclo
    xor bx,bx
    salto:
    mov ah,01h
    int 21h
    cmp al,10
    jz finalM
    cmp al,13
    jz finalM
    mov entrada[bx],al
    inc bx; DEJAR DE LEER CUANDO AL ES 10,13
    cmp bx, 100
    jnz salto
    finalM:
    pop bx
endm

separarComando macro entrada
    local search, incrementar, borrar, sepa, ciclo, salir
    xor di,di
    mov iter, 0d
    mov iter2, 0d

    jmp search
    search:
        mov al, entrada[di]
        cmp al, 95
        jz borrar
        jnz guardar

    incrementar:
        inc iter
        mov di, iter
        cmp di, 100
        jz salir
        jnz search    

    borrar:
        inc di
        inc iter
        jmp sepa

    guardar:
        mov comando[di], al
        jmp incrementar
    
    sepa:
        mov si, iter2
        mov al, entrada[di]
        inc iter
        mov di, iter
        cmp di, 100
        jz salir
        mov complemento[si], al
        ciclo:
        inc iter2
        mov si,iter2
        cmp iter2, 20
        jnz sepa
        jz salir
        
    salir:
endm

CompararCadena macro cadena1,cadenaDos
    local ciclo,fin,noigual,dolar

    push bx
    push ax
    xor bx,bx

    ciclo:
    mov al,cadena1[bx]
    cmp al,cadenaDos[bx]
    jnz noigual

    cmp al,"$"
    jz dolar

    inc bx
    cmp bx,10
    jnz ciclo
    dolar:
    mov al,1
    mov retorno,al
    jmp fin
    noigual:
    mov al,0
    mov retorno,al
    fin:
    pop ax
    pop bx

endm

Imprimir8bits macro registro
    local cualquiera,noz
    xor ax,ax
    mov al,registro
    mov cx,10
    mov bx,3
    cualquiera:
    xor dx,dx
    div cx
    push dx
    dec bx
    jnz cualquiera
    mov bx,3
    noz:
    pop dx
    ImprimirNumero dl
    dec bx
    jnz noz
endm

ImprimirNumero macro registro
    push ax
    push dx


    mov dl,registro
    ;ah = 2
    add dl,48
    mov ah,02h
    int 21h


    pop dx
    pop ax
endm

ContarPalabras macro contenedor
    local salto, sumar, dolar, comparar
    xor bx,bx
    mov bx, 0
    xor ax, ax
    mov pala, 1
    jmp salto
    salto:
        inc bx
        mov al, contenedor[bx]
        cmp al, 32
        jz sumar 
        cmp al, 36
        jz dolar
        jnz salto
    sumar:
        inc bx
        inc pala
        jmp salto
    dolar:
        xor bx, bx
        xor ax, ax
   
endm

ContarDiptongo macro contenedor
    local salto, analizar, dolar, incrementar, guardar, llenar, ultimo, nuevo
    xor di,di
    xor si, si
    mov iter, 0d
    mov iter2, 0d
    mov llenado, 0d
    jmp salto
    salto:
        mov al, contenedor[di]
        cmp al, 32
        jz analizar 
        cmp al, 36
        jz dolar
        jnz guardar
    guardar:
        mov palabraC[si], al
        jmp incrementar
    incrementar:
        inc iter2
        mov di, iter2
        inc iter
        mov si, iter
        jmp salto
    analizar:
        BuscarDiptongo palabraC
        jmp llenar
    llenar:
        mov di, llenado 
        mov al, 36
        mov palabraC[di], al
        inc llenado
        cmp llenado, 20
        jz nuevo
        jnz llenar
    nuevo:
        mov llenado, 0d
        inc iter2
        mov di, iter2
        mov iter, 0
        mov si, iter
        jmp salto
    dolar:
        jmp ultimo
    ultimo:
        BuscarDiptongo palabraC
    
endm

ContarTriptongo macro contenedor
    local salto, analizar, dolar, incrementar, guardar, llenar, ultimo, nuevo
    xor di,di
    xor si, si
    mov iter, 0d
    mov iter2, 0d
    mov llenado, 0d
    jmp salto
    salto:
        mov al, contenedor[di]
        cmp al, 32
        jz analizar 
        cmp al, 36
        jz dolar
        jnz guardar
    guardar:
        mov palabraC[si], al
        jmp incrementar
    incrementar:
        inc iter2
        mov di, iter2
        inc iter
        mov si, iter
        jmp salto
    analizar:
        BuscarTriptongo palabraC
        jmp llenar
    llenar:
        mov di, llenado 
        mov al, 36
        mov palabraC[di], al
        inc llenado
        cmp llenado, 20
        jz nuevo
        jnz llenar
    nuevo:
        mov llenado, 0d
        inc iter2
        mov di, iter2
        mov iter, 0
        mov si, iter
        jmp salto
    dolar:
        jmp ultimo
    ultimo:
        BuscarTriptongo palabraC
    
endm

BuscarDiptongo macro palabraC
    local salto, verificar, vA, vI, vH, vHH, fin, sumar, incrementar, fin
    mov iter, 0d
    mov si, iter
    salto:
        mov al, palabraC[si]
        cmp al, 97
        jz vA
        cmp al, 101
        jz vA
        cmp al, 111
        jz vA
        cmp al, 105
        jz vI
        cmp al, 117
        jz vI
        cmp al, 105
        jz vH
        cmp al, 117
        jz vHH
        cmp al, 36
        jz fin
        jnz incrementar
    vA:
        inc si
        mov al, palabraC[si]
        cmp al, 36
        jz fin
        cmp al, 105
        jz sumar
        cmp al, 117
        jz sumar
        jnz salto
    vI:
        inc si
        mov al, palabraC[si]
        cmp al, 36
        jz fin
        cmp al, 97
        jz sumar
        cmp al, 101
        jz sumar
        cmp al, 111
        jz sumar
        jnz salto
    vH:
        inc si
        mov al, palabraC[si]
        cmp al, 36
        jz fin
        cmp al, 117
        jz sumar
        jnz salto
    vHH:
        inc si
        mov al, palabraC[si]
        cmp al, 36
        jz fin
        cmp al, 105
        jz sumar
        jnz salto
    sumar:
        inc resultado
        jmp incrementar
    incrementar:
        inc si
        jmp salto
    fin:
        print msg8
        Imprimir8bits resultado
endm

BuscarTriptongo macro palabraC
    local salto, vA, vI, vU, vUU, vE, vO, vIU, vUE, vAA, vII, fin, sumar, incrementar, sumDip, subir, sumHi, soloI, sumDipT
    mov iter, 0d
    mov si, iter
    jmp salto
    salto:
        mov al, palabraC[si]
        ;Si es i
        cmp al, 105
        jz vI
        ; Si es u
        cmp al, 117
        jz vU
        ;Para diptongos
        cmp al, 97
        jz vAA
        cmp al, 101
        jz vAA
        cmp al, 111
        jz vAA
        ; Si es $
        cmp al, 36
        jz fin
        jnz incrementar
    ; si es a    
    vI:
        inc si
        inc iter
        mov al, palabraC[si]
        cmp al, 36
        jz fin
        cmp al, 105
        jz sumHi
        cmp al, 97
        jz vA
        jnz vE
    ; Si es a
    vU:
        inc si
        inc iter
        mov al, palabraC[si]
        cmp al, 36
        jz fin
        cmp al, 117
        jz sumHi
        cmp al, 97
        jz vA
        cmp al, 101
        jz soloI
        jnz vUE
    ; si es i
    vA:
        inc si
        inc iter
        mov al, palabraC[si]
        cmp al, 36
        jz subir
        cmp al, 105
        jz sumar
        jnz vUU

    vUU:
        cmp al, 36
        jz fin
        cmp al, 117
        jz sumar
        jnz sumDip
    vE:
        cmp al, 36
        jz fin
        cmp al, 101
        jz vA
        jnz vO

    vO:
        cmp al, 36
        jz fin
        cmp al, 111
        jz vII
        jnz vIU

    vIU:
        cmp al, 36
        jz subir
        cmp al, 117
        jz sumDip
        jnz incrementar

    vUE:
        cmp al, 36
        jz fin
        cmp al, 101
        jz sumDip
        cmp al, 111
        jz sumDip
        cmp al, 105
        jz sumDip
        jnz incrementar

    vAA:
        inc si
        inc iter
        mov al, palabraC[si]
        cmp al, 36
        jz fin
        cmp al, 105
        jz sumDipT
        cmp al, 117
        jz sumDipT
        cmp al, 97
        jz sumHi
        cmp al, 101
        jz sumHi
        cmp al, 111
        jz sumHi
        jnz incrementar

    vII:
        inc si
        inc iter
        mov al, palabraC[si]
        cmp al, 36
        jz subir
        cmp al, 105
        jz sumar
        jnz sumDip
    
    soloI:
        inc si
        mov al, palabraC[si]
        cmp al, 36
        jz subir
        cmp al, 105
        jz sumar
        jnz sumDip
    sumar:
        inc trip
        mov col, 2
        inc si
        inc iter
        jmp fin

    subir:
        inc resultado
        mov col, 1
        mov tipo, 1
        jmp fin

    incrementar:
        mov col, 0
        inc si 
        inc iter
        jmp salto
    
    sumDip:
        mov tipo, 1
        inc si
        inc iter
        mov col, 1
        inc resultado
        jmp fin
    sumDipT:
        mov tipo, 2
        mov col, 1
        inc si
        inc iter
        inc resultado
        jmp fin
    sumHi:
        inc si
        inc iter
        mov col, 3
        inc hia
        jmp fin
    fin:
        cmp col, 0
        colorear palabraC, col, iter
endm

media macro cantidad, total
    push bx
    xor bx,bx
    push ax
    xor ax,ax
    mov al, cantidad
    mov bl, 100
    mul bl
    div total
    mov med, al
endm

colorear macro palabraC, col, iter
    local normal, dipt, triptoo, hiatoo, verdipt, over, pintar, cicli, chu, vertript
    mov iter2, 0d
    push ax
    push bx
    push cx
    push dx
    mov di, iter
    mov bx,iter


    cmp col, 0
    jz normal
    cmp col, 1
    jz verdipt
    cmp col, 2
    jz vertript
    cmp col, 3
    jz hiatoo
    jnz over

    normal:
        print palabraC
        print espacio
        jmp over
    
    verdipt:
        mov iter2, iter
        dec iter2
        mov bx, 0
        jmp dipt
    
    vertript:
        mov iter2, iter
        dec iter2
        dec iter2
        mov bx, 0
        jmp triptoo

    pintar:
        lea bp,palabraC[bx]
        mov al,1
        mov bh,0
        mov bl,0010b;COLOR
        mov cx,2;CANTIDAD DE CARACTERES DESPUES DEL INICIO
        mov dl,iter2;COLUMNAS
        mov dh,0;FILAS
        mov ah,13h;Funcionalidad escribir STRING\CADENA
        int 10h
        jmp cicli

    pintar1:
        lea bp,palabraC[bx]
        mov al,1
        mov bh,0
        mov bl,1110b;COLOR
        mov cx,2;CANTIDAD DE CARACTERES DESPUES DEL INICIO
        mov dl,iter2;COLUMNAS
        mov dh,0;FILAS
        mov ah,13h;Funcionalidad escribir STRING\CADENA
        int 10h
        jmp cicli

    hiatoo:
        lea bp,palabraC[bx]
        mov al,1
        mov bh,0
        mov bl, 0100;COLOR
        mov cx,2;CANTIDAD DE CARACTERES DESPUES DEL INICIO
        mov dl,iter2;COLUMNAS
        mov dh,0;FILAS
        mov ah,13h;Funcionalidad escribir STRING\CADENA
        int 10h
        jmp cicli

    triptoo:
        cmp bx, iter2
        jz pintar1
        jnz cicli
        
    dipt:
        cmp bx, iter2
        jz pintar
        jnz cicli
        ;mov bp,offset hola

    cicli:
        inc iter
        mov bx, iter
        cmp bx, 36
        jz over
        jnz chu
    chu:
        printC palabraC[bx]
        print espacio
        jmp cicli
    over:
        pop dx
        pop cx
        pop bx
        pop ax
endm

LlenarVariable macro var, cantidad
    local llenar, fin
    mov llenado, 0d
    xor di,di
    llenar:
        mov di, llenado 
        mov al, 36
        mov var[di], al
        inc llenado
        cmp llenado, cantidad
        jz fin
        jnz llenar
    fin:
endm

limpiar macro 
    mov resultado, 0 
    mov hia, 0
    mov trip, 0
    mov med, 0
    mov pala, 0
    mov retorno, 0
endm
