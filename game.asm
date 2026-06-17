 

title assemblyGAME
;charalampos_lazarelis

data segment
 y db 30 ;y tou enemy
 x dw 0 ;;x tou enemy ,/x=0 gia eukolo testing / x =155-165(analoga me to dir)  gia na ksekinaei to enemy apo kentro  sto kentro
 c1 db 10 ;xrvma tou enemy (prassino)
 dir db -1;direction tou enemy   
 
 h db 180   ; ypsos trigwnou=20 ara pixel 200-20=180 
 line_number db 0 ;gia to trigwno 
 
 score dw 0 
 
 x_b dw 160 ;x tou blhmatos / kenro ths othonhs , stathero
 y_b db 177 ;y tou blhmatos / tria pixel panw apo thn korifh tou trigwnou
 msg dw "GAME OVER. Enemy moved: $"  

 ;gia print_score
 dekaxilia db 0
 xilia db 0
 ekato db 0
 deka db 0 
 monada db 0
   
data ends

code segment 
    
    jmp start: 
    
    resetdata:
    
    ; reset data  for replay---
    mov y, 30          ; 
    mov x, 0           ; 
    mov dir, -1        ; 
    mov score, 0       ; 
    mov y_b, 177       ; 
    mov line_number, 0 ; 
    ; ------------------------
    
    start: 

    
    mov ax,data
    mov ds,ax 

 
    mov ax, 0013h
    int 10h
    
    mov ax, 0A000h
    mov es, ax
    
    ;na paththei plhktro gia na ksekinisei 
    MOV AH, 00H
    INT 16H
    
    ;call trigwno
    
    
    

  
  main:
    
    mov ah,01h
    int 16h
    jz oxi_space
    
    mov ah,00h
    int 16h
    cmp al,32
   
    jne oxi_space  
    
    mov cl,y_b
    xor ch,ch
    loop_b:
     
    call blhma
    call ENEMY
     
    
    cmp dir,1
    je  right_main      ;direction
    
    
    ;left elegxos x
    mov ax,x    
    cmp ax,x_b
    ja edw 
    
    add ax,10
    cmp ax,x
    jb edw
    
    jmp y_main
    
    ;right elegxos x     
    right_main:
   
    mov ax,x
    cmp ax,x_b
    jb edw 
    
    sub ax,10
    cmp ax,x_b
    ja edw 
    
    ;elegxos y 
    y_main: 
    mov bl,y
    xor bh,bh
    cmp bl,y_b 
    jb  edw
    xor ax,ax
    mov al,y_b
    
    add al,6
    cmp bl,al
    
    ja edw  
   
    ;egine sugkroush
    jmp telos_main  
    ;.
    
    
    ;den egine sugkroush 
    edw:
     
    loop loop_b
     
    
   oxi_space: 
   ;kaleitai panta 
     
    call ENEMY 
    
    
    
    jmp main
 
                               
                           

    
       
    telos_main: 
    
    call enemy_del
    
    ;termatismos leitourgias grafikwn
    mov ax, data
    mov ds, ax
    mov ax,0003h     
    int 10h   
    
    lea dx,msg
    mov ah,9
    int 21h
    call print_score 
    
    
    ;replay
    MOV AH, 00H
    INT 16H
    
 
    jmp resetdata
    
    MOV AH, 4CH
    INT 21H 
                 
                
             
                 
ENEMY_RIGHT PROC
    
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH ES
    
                                                                              
   
    


                 
    MOV BL,c1
    XOR BH, BH

    
    xor ax,ax
    mov ax,320  ;x tou deksiou oriou

    ;mov cx,10

   ; loop_right: 
    
    CMP ax,x
    JE right_border
        
    MOV ES:[SI], BL
    MOV ES:[SI-10],0
    INC SI
    inc x
    inc score
    ;loop loop_right 
    
    jmp end_right
    
  
  
  right_border: 
     mov dir,-1
     sub x,10 ;(giati alliws to enemy_left ksekinaei apo to x =320 kai o exthros tha faientai san na bgaien iapo to telos tou parathurou\
     add score,10
     call change_y 
    
    
     
  end_right:
    
   
    POP ES
    POP DX
    POP CX
    POP BX
    
    RET
ENEMY_RIGHT ENDP 

ENEMY_LEFT PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH ES
  
  
    
    MOV BL,c1
    XOR BH, BH
    
    mov ax,0 ;x==0 aristero orio
    CMP ax,x
    JE left_border

                 



    ;mov cx,10
    
    ; loop_left:
    cmp ax,x
    je left_border    
    MOV ES:[SI], BL
    MOV ES:[SI+10],0
    dec SI
    dec x
    inc score
    ; loop loop_left 
    jmp end_left
    
  
    left_border:
  
     add x,10 ;
     add score,10
     mov dir,1 
     call change_y 
     

    end_left: 

    POP ES
 
    POP CX
    POP BX
    POP AX
    RET
ENEMY_LEFT ENDP

ENEMY PROC

    PUSH AX
    PUSH BX
    PUSH ES
    PUSH SI
  
             
             
             
    ;ypologismos pixel si  320*y+x 
    xor ax,ax        
    mov Al,y 
    xor ah,ah
    shl ax,6
    mov bl,y
    xor bh,bh
    shl bx,8
    add ax,bx
    add ax,x 
    mov si,ax
    
    

    
    cmp dir,1   ;elegxos direction
    je  right
    
    
    call ENEMY_LEFT 
    
    jmp telos
    
   right:
    call ENEMY_RIGHT  
     
    
   telos:   

   
    
    
    POP SI
    POP ES
    POP BX
    POP AX
    RET    
    
    

    
ENEMY ENDP  


change_y proc 
    push si
    push cx
    push bx
    
    call delay_loop
    
    add y,1
    inc score
    
    
    
    MOV BL,10
    XOR BH, BH
    mov cx,10 ;10 pixel =10 epanalhpseis 
    
    
     cmp dir,-1
     je _LOOP1
  _LOOP:
      
    mov es:[si+1], 0  ;gia na diafrafontai ola ta pixel
    MOV es:[si+320],bl ;ena pixel pio katw 
    inc si
     
    LOOP _LOOP 
    jmp telos1
   
                    
 



_LOOP1: 

                       
    mov es:[si-1], 0  
    mov es:[si+320],bl
    dec SI 
    loop _LOOP1 
    jmp telos1
    
    
    
    
    
    
  telos1:  
    pop bx 
    pop cx        
    pop si         
   ret
   
change_y endp   

trigwno proc 
    PUSH AX
    PUSH BX
    PUSH ES
    PUSH SI
    
    ;ypologismos pixel sl korifh trigvnou       
    mov Al,h 
    xor ah,ah
    shl ax,6
    mov bl,h
    xor bh,bh
    shl bx,8
    add ax,bx
    add ax,160 ; kentro ths othonhs 
    mov si,ax  
    
    
    MOV BL,100
    XOR BH, BH  
    
    
    MOV ES:[SI],bl  ;koryfh
    inc line_number
  loopa: 
    xor ax,ax
    mov al,line_number
    cmp al,20   ;entolh termatismoy epanalhpsewn, otan line_number = h=30
    je  tleos_trig
     
    inc line_number
    add si,320
    
    
    
    push si
    sub si,ax
    
    mov cx,ax
    add cx,ax ;ksekianei na typvnei apo si-line_number ews kai  si+line, ara aritmos epanalhpsewn gia kathe grammh einai (line_number*2)+1 
    add cx,1     
   loopa2:

    MOV ES:[SI],bl
    inc si
    
    loop loopa2
    
    pop si   ; gia na ,hn xanetai to kentro 
 
    jmp loopa
     
    
    
    
    
    
    
  tleos_trig:  
    POP SI
    POP ES
    POP BX
    POP AX
    RET  




trigwno endp 

 
 
 


delay_loop proc
    push ax
    push bx
    push dx
    
    MOV AH, 00h 
    INT 1Ah          
    MOV BX, DX       
    ADD BX, 1        
    
Label_Wait:  
    INT 1Ah          
    CMP DX, BX       
    JB Label_Wait   
    
    pop dx
    pop bx
    pop ax
    ret
delay_loop endp 

blhma proc
    PUSH AX
    PUSH BX
    PUSH ES
    PUSH SI
    push cx     
     
    ;ypologismos pixel si 320*y_b+x_b       
    mov Al,y_b
    
    xor ah,ah
    
    mov bl,al
    xor bh,bh
    shl ax,6
    shl bx,8
    add ax,bx
    add ax,x_b ; kentro 
    mov si,ax
                    
  
    xor ax,ax
  
    mov al,0          ;bullet == panw orio othonhs
    xor ah,ah
    cmp al,y_b
    jne  oxi_top      
    
  
    mov y_b,177   ;  to shmeio poy ksekinaei to bullet
    
        
    oxi_top:
    
    ;mov cx,3
   ; loop_speed:
    
    
    MOV ES:[SI],100 
    
    mov bl,y_b
    cmp bl,174       ;trei epanalhpseis xwris na bafei mayro , gia na mhn sbhnei to trigvno
    ja  a
    MOV ES:[SI+960],0  ;3*320 dhladh tria pixel pio katw 
    a:
    
    dec y_b 
    ;loop loop_speed
      
 
    pop cx
    POP SI
    POP ES
    POP BX
    POP AX
    RET 
blhma endp    

print_score proc
    push ax
    push bx
    push cx
    push dx
    
    mov ax, score
    
    ; 10000
    mov bx, 10000
    xor dx, dx        
    div bx            
    mov dekaxilia, al        
    
    ; 1000
    mov ax, dx        
    xor dx, dx
    mov bx, 1000
    div bx            
    mov xilia, al        
    
    ; 100
    mov ax, dx        
    xor dx, dx
    mov bx, 100
    div bx            
    mov ekato,al           
    
    ; 10
    mov ax, dx        
    xor dx, dx
    mov bl, 10
    div bl            
    mov monada, ah        
    mov deka, al        
    
  
  
    mov dl, dekaxilia
    add dl, '0'
    mov ah, 02h
    int 21h
    
    
    mov dl, xilia
    add dl, '0'
    mov ah, 02h
    int 21h
    
    ; 
              
    mov al, ekato       
    mov dl, al
    add dl, '0'
    mov ah, 02h
    int 21h
    
    ;
    mov dl, deka
    add dl, '0'
    mov ah, 02h
    int 21h
    
    ;
    mov dl, monada
    add dl, '0'
    mov ah, 02h
    int 21h
    
    pop dx
    pop cx
    pop bx
    pop ax
    ret
print_score ENDP


 enemy_del proc  
    PUSH AX
    PUSH BX
    PUSH ES
    PUSH SI
    
  
             
             
             
    ;ypologismos pixel si 320*y+x
    xor ax,ax        
    mov Al,y 
    xor ah,ah
    shl ax,6
    mov bl,y
    xor bh,bh
    shl bx,8
    add ax,bx
    add ax,x 
    mov si,ax
    
    

    mov cx,10
    
    cmp dir,1 
    je  right_del
    
    
           ;10 epanalhpseis gia 10 pixel
    
     loop_left_del:
       
    
    MOV ES:[SI+10],0
    dec SI
 
     loop loop_left_del 
   
    
    jmp telos
    
   right_del:
        

    loop_right_del: 
    

        
   
    MOV ES:[SI-10],0
    INC SI
  
    loop loop_right_del 
     
    
   telos_del:   

   
    
    
    POP SI
    POP ES
    POP BX
    POP AX
    RET    
    
    
    
    
    
    
 enemy_del endp   
 
 


   
    
CODE ENDS
END start  