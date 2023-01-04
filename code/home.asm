
public msg,presskey,option1,option2,option3,msg1,msg2,username,x,y
public printmsg,clearscreen,movecursor,getName,startMenu,sent,recvied,sentGame,recviedGame

;;;;;;;;;;;;;;;;;;; INCLUDE DRAW DATA ;;;;;;;;;;;;
    EXTRN white_bishop:BYTE
    EXTRN white_king:BYTE
    EXTRN white_knight:BYTE
    EXTRN white_pawn:BYTE
    EXTRN white_queen :BYTE
    EXTRN white_rock:BYTE

    EXTRN black_bishop:BYTE
    EXTRN black_king:BYTE
    EXTRN black_knight:BYTE
    EXTRN black_pawn:BYTE 
    EXTRN black_queen:BYTE
    EXTRN black_rock :BYTE
    EXTRN board :BYTE
    EXTRN RowColumnpiece :BYTE
    EXTRN Colour :BYTE
    EXTRN Colour1 :BYTE 
    EXTRN Colour2 :BYTE
    EXTRN StartPixel :WORD

    EXTRN playerColour :BYTE
    EXTRN playerColour2 :BYTE
    
    
    EXTRN clear :FAR
    EXTRN pieceType :FAR
    EXTRN GetStartPixel:FAR
    EXTRN getPiecePixel:FAR
    EXTRN DrawCell:FAR
    EXTRN DrawGrid:FAR
    EXTRN drawPiece:FAR
    EXTRN drawMainBoard:FAR ;functions
.286

.MODEL Large 
.STACK 64

.DATA
  msg               db "Please Enter Your Name: $"
  errmsg            db "invalid name. Your name must be lowercase english charactars only$"
  pressanykey       db "Press any key to continue$"
  presskey          db "Press Enter Key to continue $"
  option1           db "To start chatting press F1$"
  option2           db "To start the game press F2$"
  option4           db "To return to main menu press F4$"
  option3           db "To end the program press ESC$"
  notification1     db "- You Sent a Chat Invitation $"
  notification2     db "- You have been sent a chat invitation. To accept press f1$"
  gameNotification1 db "- You Sent a game Invitation $"
  gameNotification2 db "- You have been sent a game invitation. To accept press f2$"
  extmsg            db "The game has ended$"
  notX1             db 0
  notY1             db 24
  notX2             db 0
  notY2             db 25
  msg1              db "Chatting mode$"
  msg2              db "Ending the Program...$"
  linemsg           db "--------------------------------------------------------------------------------$"
  username          db 20,?,20 dup('$')
  x                 db ?
  y                 db ?
  xc                DB 0
  yc                DB 12

  xc1               DB 0
  yc1               DB 1
  xc2               DB 0
  yc2               DB 14
  
  memsg             DB "ME:$"
  youmsg            DB "YOU:$"
  SENDVALUE         DB ?
  SENDVALUEH         DB ?
  VALUE             DB ?
  VALUEH             DB ?
  sent              db 0
  recvied           db 0
  sentGame          db 0
  recviedGame       db 0



.CODE



printmsg proc FAR                                   ;offset has to be in dx before calling
                pusha
                mov   ah,9
                int   21h
                popa
                ret
printmsg endp
 
clearscreen proc far
                pusha
                mov   ax,003h
                int   10h
                popa
                ret
clearscreen endp

movecursor PROC far
                pusha
                mov   dl,x
                mov   dh,y
                mov   bh,0
                mov   ah,2
                int   10h
                popa
                ret
                endp
movecursorc PROC far
                pusha
                mov   dl,xc
                mov   dh,yc
                mov   bh,0
                mov   ah,2
                int   10h
                popa
                ret
                endp


Initalize PROC FAR
                pusha
                mov   dx,3fbh                       ; Line Control Register
                mov   al,10000000b                  ;Set Divisor Latch Access Bit
                out   dx,al                         ;Out it

                mov   dx,3f8h
                mov   al,0ch
                out   dx,al


                mov   dx,3f9h
                mov   al,00h
                out   dx,al


                mov   dx,3fbh
                mov   al,00011011b
  ;0:Access to Receiver buffer, Transmitter buffer
  ;0:Set Break disabled
  ;011:Even Parity
  ;0:One Stop Bit
  ;11:8bits
                out   dx,al
                popa
                ret
Initalize ENDP

SendScroll PROC FAR
                pusha
                mov   ax,0601h
                mov   bh,07
                mov   cx,0100H
                mov   dx,0B4fH
                int   10h

                MOV   xc1, 0
                MOV   yc1, 11
                MOV   AL,xc1
                MOV   AH,yc1
                MOV   x,AL
                MOV   y,AH
                CALL  movecursor

                popa
                ret
               
SendScroll ENDP

RecieveScroll PROC FAR
                pusha
                mov   ax,0601h
                mov   bh,07
                mov   cx,0E00H
                mov   dx,184fH
                int   10h

                MOV   xc2, 0
                MOV   yc2, 24
                MOV   AL,xc2
                MOV   AH,yc2
                MOV   x,AL
                MOV   y,AH
                CALL  movecursor
                
                popa
                ret
                  
RecieveScroll ENDP

ChattingMode proc far
                pusha
                MOV   AX,03H
                INT   10H

                CALL  Initalize
        

  sscc:         MOV   x,0
                MOV   y,0
                CALL  movecursor

                MOV   DX,OFFSET memsg
                CALL  printmsg

                MOV   x,0
                MOV   y,12
                CALL  movecursor

                MOV   DX,OFFSET linemsg
                CALL  printmsg

                      
                MOV   x,0
                MOV   y,13
                CALL  movecursor

                MOV   DX,OFFSET youmsg
                CALL  printmsg


                MOV   x,0
                MOV   y,1
                CALL  movecursor

               


  RECIEVING:    mov   dx , 3FDH                     ; Line Status Register
                in    al , dx
                AND   al , 1
                JZ    IO
                JMP   IOO
  IO:           JMP   SENDING

  IOO:          mov   dx , 03F8H
                in    al , dx
                mov   VALUE , al

                cmp VALUE,61
                jnz contRecieve
                jmp extChat
                contRecieve:

                CMP   VALUE,13
                JZ    ENTERLINE1
                JMP   FSS1

  ENTERLINE1:   INC   yc2
                MOV   xc2,0
                MOV   AL,xc2
                MOV   AH,yc2
                MOV   x,AL
                MOV   y,AH
                CALL  movecursor
                jmp   kkk1

  FSS1:         CMP   VALUE,8
                JZ    BACKSPACE1
                JMP   xxs1

  BACKSPACE1:   
                CMP   Xc2,0
                JNZ   CANBS2
                CMP   Yc2,14
                JNZ   CANBS2
                JMP   kkk1

  CANBS2:       CMP   Xc2,0
                JNZ   CANBS3
                MOV   xc2,79
                DEC   Yc2
                MOV   BH,Xc2
                MOV   BL,Yc2
                MOV   x,BH
                MOV   y,BL
                CALL  movecursor
                mov   ah,2
                mov   dl,' '
                int   21h
                MOV   BH,Xc2
                MOV   BL,Yc2
                MOV   x,BH
                MOV   y,BL
                CALL  movecursor
                JMP   kkk1


  CANBS3:       DEC   Xc2
                MOV   BH,Xc2
                MOV   BL,Yc2
                MOV   x,BH
                MOV   y,BL
                CALL  movecursor
                mov   ah,2
                mov   dl,' '
                int   21h
                MOV   BH,Xc2
                MOV   BL,Yc2
                MOV   x,BH
                MOV   y,BL
                CALL  movecursor
                jmp   kkk1
                      
  xxs1:         MOV   AL,xc2
                MOV   AH,yc2
                MOV   x,AL
                MOV   y,AH
                CALL  movecursor
                mov   ah,2
                mov   dl,VALUE
                int   21h
                cmp   Xc2,79
                jz    kline1
                INC   Xc2
                JMP   kkk1

  kline1:       mov   xc2,0
                inc   yc2

  kkk1:         
                cmp   yc2,25
                JB    SENDING
                call  RecieveScroll
  ;   jmp   sscc

 
  SENDING:      mov   dx , 3FDH                     ; Line Status Register
                In    al , dx                       ;Read Line Status
                AND   al , 00100000b
                JZ    II
                JMP   III
  II:           JMP   RECIEVING
               
  III:          mov   ah,1
                int   16h
                JZ    II

                MOV   SENDVALUE,AL
                MOV   SENDVALUEH,AH
                CMP   SENDVALUE,8
                JZ    BACKSPACE
                MOV   AH,0Ch
                INT   21h

                CMP   SENDVALUE,13
                JZ    ENTERLINE
                JMP   FSS

  ENTERLINE:    INC   yc1
                MOV   xc1,0
                MOV   AL,xc1
                MOV   AH,yc1
                MOV   x,AL
                MOV   y,AH
                CALL  movecursor
                jmp   kkk

  FSS:          CMP   SENDVALUE,8
                JZ    BACKSPACE
                JMP   xxs

  BACKSPACE:    
                mov   ah,07
                int   21h
                CMP   Xc1,0
                JNZ   CANBS
                CMP   Yc1,1
                JNZ   CANBS
                JMP   kkk

  CANBS:        CMP   Xc1,0
                JNZ   CANBS1
                MOV   xc1,79
                DEC   Yc1
                MOV   BH,xc1
                MOV   BL,yc1
                MOV   x,BH
                MOV   y,BL
                CALL  movecursor
                mov   ah,2
                mov   dl,' '
                int   21h
                MOV   BH,xc1
                MOV   BL,yc1
                MOV   x,BH
                MOV   y,BL
                CALL  movecursor
                JMP   kkk

  CANBS1:       DEC   xc1
                MOV   BH,xc1
                MOV   BL,yc1
                MOV   x,BH
                MOV   y,BL
                CALL  movecursor
                mov   ah,2
                mov   dl,' '
                int   21h
                MOV   BH,xc1
                MOV   BL,yc1
                MOV   x,BH
                MOV   y,BL
                CALL  movecursor
                jmp   kkk

  xxs:          MOV   AL,xc1
                MOV   AH,yc1
                MOV   x,AL
                MOV   y,AH
                CALL  movecursor
                mov   ah,2
                mov   dl,SENDVALUE
                int   21h
                cmp   Xc1,79
                jz    kline
                INC   Xc1
                JMP   kkk

  kline:        mov   xc1,0
                inc   yc1
                mov   dx , 3F8H                     ; Transmit data register
                mov   al, 13
                out   dx , al

  kkk:            cmp SENDVALUEH,61
                jz extchatSend       
                mov   dx , 3F8H                     ; Transmit data register
                mov   al, SENDVALUE
                out   dx , al
                
           
                cmp   yc1,12
                JB    LL
                call  SendScroll
  ;  jmp   sscc



  LL:           
                JMP   RECIEVING
                extchatSend:
                     mov   dx , 3F8H                     ; Transmit data register
                mov   al, SENDVALUEH
                out   dx , al
                extChat:
                call clearscreen
                mov sent,0
                mov recvied,0
                mov sentGame,0
                mov recviedGame,0
                popa
                ret


ChattingMode endp




getName proc far
      
 
                call  clearscreen
 
                mov   y,2
                mov   x,1
                call  movecursor
 
                mov   dx,offset msg
                call  printmsg
                mov   y,4
                mov   x,1
                call  movecursor
                jmp   nameloop
  errline:      call  clearscreen
                mov   x,1
                mov   y,6
                call  movecursor
                mov   dx,offset errmsg
                call  printmsg
                mov   x,1
                mov   y,8
                call  movecursor
                mov   dx,offset pressanykey
                call  printmsg
                mov   ah,0
                int   16h
                call  clearscreen
                mov   y,2
                mov   x,1
                call  movecursor
 
                mov   dx,offset msg
                call  printmsg
  nameloop:     mov   ah,0Ah                        ;get username from user
                mov   dx, offset username
                int   21h
                mov   si,offset username+2
                mov   cx,18
                mov   al,[si]
                cmp   al,13
                jz    errline
  loooop:       
                mov   al,[si]
                cmp   al,13
                jz    extuser
                cmp   al,36
                jz    errline
                cmp   al,97
                js    errline
                cmp   al,122
                jg    errline
                inc   si
                loop  loooop

  extuser:      
                mov   y,20
                mov   x,1
                call  movecursor
 
                mov   dx,offset presskey
                call  printmsg
 
  line:         mov   ah,0                          ;get key pressed
                int   16h
          
                cmp   al,13                         ;check if the key is 'enter' key
                jnz   line
 
                call  clearscreen
                ret
getName endp

startMenu PROC FAR
              startMenuStart:
                mov   y,6
                mov   x,25

                call  movecursor
 
                mov   dx,offset option1
                call  printmsg
                mov   y,9
                mov   x,25
                call  movecursor
                mov   dx,offset option2
                call  printmsg

                mov   y,12
                mov   x,25
                call  movecursor
                mov   dx,offset option3
                call  printmsg
 
  ;mov ah,0    ;get key pressed
  ; int 16h
          
  ;cmp ah,59
  ;jz f1
  ;  cmp ah,60
  ;  jz f2
  ;  cmp al,27
  ;  jz esc1
 
  ;jmp l1
 
  f1:           
                call  Initalize
  initLoop:     
                cmp   sent,1
                jnz   RECIEVING2
                cmp   recvied,1
                jnz   RECIEVING2
                jmp   startchat
  RECIEVING2:   mov   dx , 3FDH                     ; Line Status Register
                in    al , dx
                AND   al , 1
                JZ    SENDING2
                mov   dx , 03F8H
                in    al , dx
                mov   VALUE , al
                cmp   VALUE,59
                jz    recieveChat
                cmp   VALUE,60
                jz    recieveGame
               
                jmp   SENDING2
  recieveChat:  
                cmp   recvied,1
                jz    SENDING2
                mov   recvied,1
                mov   x,0
                mov   y,24
                call  movecursor
                mov   dx, offset notification2
                call  printmsg
                jmp   SENDING2
  recieveGame:  
                cmp   recviedGame,1
                jz    SENDING2
                cmp   sentGame,1
                jnz   contrecive1
                mov   playerColour,1
                mov   playerColour2,0
                jmp   f2
  contrecive1:  
                mov   recviedGame,1
                mov   x,0
                mov   y,23
                call  movecursor
                mov   dx, offset gameNotification2
                call  printmsg



      
              

  SENDING2:     mov   dx , 3FDH                     ; Line Status Register
                In    al , dx                       ;Read Line Status
                AND   al , 00100000b
                JnZ   contSend2
                jmp   initLoop
  contSend2:    
                mov   ah,1                          ;get key pressed
                int   16h
                jnz   contSend3
                
                jmp   initLoop
               
  contSend3:    
                cmp   al,27
                jz    exitgame
                cmp   ah,59
                jz    sendChat
                cmp   ah,60
                jz    sendGame
                       mov   ah,0ch
                       int   21h
                jmp   initLoop
  sendChat:     
 jmp linnnne
    exitgame:     call clearscreen
                  mov x,25
                  mov y,12
                  call movecursor
                  mov dx, offset extmsg
                  call printmsg
                  mov ah,4Ch          ;DOS "terminate" function
                  int 21h   
linnnne:
                MOV   AH,0Ch                        ; clear buffer
                INT   21h

                mov   dx , 3F8H                     ; Transmit data register
                mov   al, 59
                out   dx , al
                cmp   sent,1
                jnz   contSend4
                jmp   initLoop
  contSend4:    
                mov   sent,1
                mov   x,0
                mov   y,24
                call  movecursor
                mov   dx, offset notification1
                call  printmsg
  ;CMP   SENDVALUE,59
  ;JZ    startchat
                JMP   initLoop


  sendGame:     
                MOV   AH,0Ch                        ; clear buffer
                INT   21h
                mov   dx , 3F8H                     ; Transmit data register
                mov   al,60
                out   dx,al
                cmp   recviedGame,1
                jnz   contSend6
                mov   playerColour,0
                mov   playerColour2,1
                jmp   f2
  contSend6:    
                cmp   sentGame,1
                jnz   contSend5
                jmp   initLoop
  contSend5:    
                mov   sentGame,1
                mov   x,0
                mov   y,23
                call  movecursor
                mov   dx, offset gamenotification1
                call  printmsg
                jmp   initLoop


  ; MOV   SENDVALUE,al
  ; mov   dx , 3F8H           ; Transmit data register
  ;mov   al, SENDVALUE
  ;out   dx , al
               
  ;jmp RECIEVING2
        
              
  startchat:    
            
                call  clearscreen
                mov   y,0
                mov   x,0
                call  movecursor
                call  ChattingMode
 
                jmp  startMenuStart 
 
  esc1:         
                mov   y,15
                mov   x,1
                call  movecursor
                mov   dx,offset msg2
                call  printmsg
                mov   ah,4ch
                int   21h
                mov   dx,offset msg2
                call  printmsg
            
                jmp   exit1
                
  f2:           mov   ax, 13h                       ;starting graphics mode
                int   10h
                call  drawMainBoard

  exit1:        
         
                ret
startMenu ENDP

Main proc far
                mov   ax,@data
                mov   ds,ax
                call  getName
                call  startMenu
Main endp
END Main