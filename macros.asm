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
    cmp bx,100
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
    cmp bx,100
    jnz salto
    finalM:
    pop bx
endm

separarComando macro entrada
    xor di,di
   
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
        mov complemento[si], al
        ciclo:
        inc iter2
        mov si,iter2
        cmp iter2, 20
        jnz sepa
        jz salir
        
    salir:
        pop si
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