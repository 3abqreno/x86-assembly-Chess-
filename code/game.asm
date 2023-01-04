.286
public playerColour,playerColour2
;;;;;;;;;;;; INCLUDE HOME DATA;;;;;;;;;;;;;;;;;;;;;;;;;
EXTRN msg :BYTE
EXTRN presskey :BYTE
EXTRN option1 :BYTE
EXTRN option2 :BYTE
EXTRN option3 :BYTE
EXTRN msg1 :BYTE
EXTRN msg2 :BYTE
EXTRN username :BYTE
EXTRN x :BYTE
EXTRN y :BYTE



EXTRN printmsg :FAR
EXTRN clearscreen :FAR
EXTRN movecursor :FAR
EXTRN getName :FAR
EXTRN startMenu :FAR

;;;;;;;;;;;;;;;;;;;;;;INCLUDE DRAW DATA;;;;;;;;;;;;;;;;;;;;;;;;
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
EXTRN refrenceBoard :BYTE
EXTRN RowColumnpiece :BYTE
EXTRN Colour :BYTE
EXTRN Colour1 :BYTE 
EXTRN Colour2 :BYTE
EXTRN StartPixel :WORD
    
EXTRN Row :BYTE
EXTRN Column :BYTE
EXTRN piece :BYTE
EXTRN player1Board:BYTE
EXTRN player2Board:BYTE
EXTRN timeBoard:WORD

EXTRN sent:BYTE
EXTRN recvied:BYTE
EXTRN sentGame:BYTE
EXTRN recviedGame:BYTE

EXTRN SENDVALUE:BYTE
EXTRN VALUE:BYTE



EXTRN clear :FAR
EXTRN pieceType :FAR
EXTRN GetStartPixel:FAR
EXTRN getPiecePixel:FAR
EXTRN DrawCell:FAR
EXTRN DrawGrid:FAR
EXTRN drawPiece:FAR
EXTRN drawMainBoard:FAR ;functions
EXTRN GetColour:FAR 
EXTRN DrawCheckCell:FAR 
EXTRN DrawStatusLine:FAR 


.MODEL SMALL
.STACK 64
.DATA

    chat1Row          db  2
    chat1Column       db  29
    chat2Row          db  21
    chat2Column       db  29


    win               db  0
    x1                db  4
    y1                db  7
    x2                db  4
    y2                db  0
    prevX             db  ?
    prevY             db  ?


    chatx1 db ?
    chaty1 db ?
    chatx2 db ?
    chaty2 db ?

    storedPos1        db  60
    storedx1          db  4
    storedy1          db  7

    storedPos2        db  4
    storedx2          db  4
    storedy2          db  0

    moveTurn          db  0
    statusbarRow1     db  0                                                   ;start of status bar for player1
    statusbarColumn1  db  25
    statusbarcolour1  equ 64h
    statusbarRow2     db  13                                                  ;start of status bar for player2
    statusbarColumn2  db  25
    statusbarcolour2  equ 67h


    WhiteWinMSG       DB  "WINNER WINNER CHICKEN DINNER!!! Player 1 wins$"
    BlackWinMSG       DB  "WINNER WINNER CHICKEN DINNER!!! Player 2 wins$"


    PieceColour       DB  ?
    ;******allam******
    dxKnight          db  1, 1, 2, 2, -1, -1, -2, -2
    dyKnight          db  2, -2, 1, -1, 2, -2, 1, -1

    dxKing            db  0, 0, 1, -1, 1, -1, 1, -1
    dyKing            db  1, -1, 0, 0, 1, -1, -1, 1
    
    diff              db  ?

    otherBoardColour  db  ?                                                   ;used for clearBoarrd function


    highlight1        equ 42h
    highlight2        equ 51h

    movmentHighlight1 equ 5ah
    movmentHighlight2 equ 83h

    CurrX             DB  ?
    CurrY             DB  ?
    CurrHighlight     db  ?
    CurrPieceColour   db  ?

    startHour         db  ?
    startMinute       db  ?
    startSecond       db  ?
    prevSecond        db  ?
    time              dw  ?
    min               db  "$$ : $"
    sec               db  "$$$"

    check1            db  ?
    check2            db  ?
    
    kx1               db  4
    ky1               db  7
    
    kx2               db  4
    ky2               db  0

    playerColour      db  0
    playerColour2     db  1

    ReceiveExit       DB  0
    SendExit          DB  0
    pieceicon         DB  0

    coord1            db  ?
    coord2            db  ?

    chattingRow1      db  1                                                   ;start of status bar for player1
    chattingColumn1   db  25
    chattingRow2      db  14                                                  ;start of status bar for player2
    chattingColumn2   db  25
    

.CODE


    ;allam
getBoardDiff proc FAR                                          ;takes row and column and returns the diff you need to add to get to the base
                             pusha
                             mov   al,Row
                             mov   ah ,8
                             mul   ah                          ;row is in al
                             mov   ah,0
                             add   al,Column
                             mov   diff,al
                             popa
                             ret
                             endp  getBoardDiff




getPieceBoard proc FAR
                             pusha
                             call  getBoardDiff
                             mov   bl,diff
                             mov   bh,0
                             mov   ah,board[bx]                ; now piece is in ah
                             mov   piece,ah                    ; now we know which piece is in row and col
                             popa
                             ret
                             endp  getPieceBoard


checkTime proc Far
                             pusha
                             mov   cl,0                        ;col
                             mov   ch,0                        ;row
                             mov   Row,0
                             mov   Column,0
                             lea   si,board                    ; takes the board pieces
                             lea   di,timeBoard
    TimeGrid:                
                             mov   dx,time
                             mov   ax,[di]
                             sub   dx,ax
                             cmp   dx,3
                             je    normalColour
                             jl    contTime3
                             jmp   dontDraw
    contTime3:               
                             cmp   dx,1
                             je    darkRed2
                             cmp   dx,0
                             je    darkRed
                             mov   colour,04h                  ;very light
                             jmp   drCell
    darkRed2:                
                             mov   colour,71h
                             jmp   drCell
    darkRed:                 
                             mov   colour,0b8h                 ;dark colour
                             jmp   drCell

                             jmp   drCell
    normalColour:            
                             mov   al,Column
                             mov   ah,Row
    ;checking if in previous square if player 1 is there
                         
                             cmp   al,x1
                             jne   firTime
                             cmp   ah,y1
                             jne   firTime
                             mov   Colour,highlight1
                             jmp   drCell
    firTime:                 
    ;checking if in previous square if player 2 is there
                             cmp   al,x2
                             jne   checkHighllight1Time
                             cmp   ah,y2
                             jne   checkHighllight1Time
                             mov   Colour,highlight2
                             jmp   drCell
    checkHighllight1Time:    
                             call  getBoardDiff
                             mov   bl,diff
                             mov   bh,0
                             mov   al,player1Board[bx]
                             cmp   al,1
                             jnz   checkHighllight2Time
                             mov   Colour,movmentHighlight1
                             jmp   drCell



    checkHighllight2Time:    
                             mov   al,player2Board[bx]
                             cmp   al,1
                             jnz   getColourTime
                             mov   Colour,movmentHighlight2
                             jmp   drCell

    getColourTime:           
                             call  GetColour
    drCell:                  
                             call  DrawCell

    checkPiece:              
                             mov   al,[si]
                             cmp   al,0                        ;if the board piece is zero that means nothing to draw
                             jz    dontDraw
                             mov   piece,al
                             call  drawPiece
    dontDraw:                
                             inc   Column
                             inc   cl
                             inc   si
                             add   di,2
                             cmp   cl,8
                             jz    contTime1
                             jmp   TimeGrid
    contTime1:               
                             mov   cl,0
                             mov   Column,0
                             inc   ch
                             inc   Row
                             cmp   ch,8
                             jz    contTime2
                             jmp   TimeGrid
    contTime2:               
                             popa
                             ret
                             endp  checkTime


drawHilightPlayer proc FAR
                             pusha
                             
                             call  DrawCell
                             call  getPieceBoard
                             cmp   piece,0
                             je    prev
                             call  drawPiece


    prev:                    
                             mov   al,prevX
                             mov   ah,prevY
                             mov   Row,ah
                             mov   Column,al

 

    ;checking if in previous square if player 1 is there
                         
                             cmp   al,x1
                             jne   fir
                             cmp   ah,y1
                             jne   fir
                             mov   Colour,highlight1
                             jmp   dr
    fir:                     
    ;checking if in previous square if player 2 is there
                             cmp   al,x2
                             jne   checkHighllight1
                             cmp   ah,y2
                             jne   checkHighllight1
                             mov   Colour,highlight2
                             jmp   dr
    checkHighllight1:        
                             call  getBoardDiff
                             mov   bl,diff
                             mov   bh,0
                             mov   al,player1Board[bx]
                             cmp   al,1
                             jnz   checkHighllight2
                             mov   Colour,movmentHighlight1
                             jmp   dr



    checkHighllight2:        
                             mov   al,player2Board[bx]
                             cmp   al,1
                             jnz   get
                             mov   Colour,movmentHighlight2
                             jmp   dr

    get:                     
                             call  GetColour
    dr:                      
                             call  DrawCell

                             call  getPieceBoard
                             cmp   piece,0
                             jZ    hiPlayer
                             call  drawPiece
    hiPlayer:                
                             call  checkTime

                             popa
                             ret
                             endp  drawHilightPlayer




PlayerMovment proc Far
                             pusha
    

                             cmp   playerColour,1
                             jnz   hiBlack
                             mov   colour,highlight1
                             jmp   contMovment
    hiBlack:                 
                             mov   colour,highlight2
                             jmp   downPlayer2

    ;Player 1
    contMovment:             

                             cmp   aL,72                       ;W UP
                             jne   down
                             cmp   y1,0
                             jnz   up1
                             jmp   PlayerMovmentExit
  
    up1:                     
                             mov   al,x1
                             mov   ah,y1
                             mov   prevX,al
                             mov   prevY,ah
                             dec   y1
                             dec   ah
                             mov   Column,al
                             mov   Row,ah
                             jmp   drawHighlight


    down:                    
                             cmp   aL,80                       ;S down
                             jne   right
                             cmp   y1,7
                             jnz   down1
                             jmp   PlayerMovmentExit
    down1:                   
                             mov   al,x1
                             mov   ah,y1
                             mov   prevX,al
                             mov   prevY,ah
                             inc   y1
                             inc   ah
                             mov   Column,al
                             mov   Row,ah
                             jmp   drawHighlight

    right:                   
                             cmp   aL,77                       ;d right
                             jne   left

                             cmp   x1,7
                             jnz   right1
                             jmp   PlayerMovmentExit
    right1:                  
                             mov   al,x1
                             mov   ah,y1
                             mov   prevX,al
                             mov   prevY,ah
                             inc   x1
                             inc   al
                             mov   Column,al
                             mov   Row,ah
                             jmp   drawHighlight

    


    left:                    
                             cmp   aL,75                       ;a left
                             je    left22
                             jmp   PlayerMovmentExit
    left22:                  
                             cmp   x1,0
                             jne   left1
                             jmp   PlayerMovmentExit
    left1:                   
                             mov   al,x1
                             mov   ah,y1
                             mov   prevX,al
                             mov   prevY,ah
                             dec   x1
                             dec   al
                             mov   Column,al
                             mov   Row,ah
                             jmp   drawHighlight

                             



    ;Player 2
    downPlayer2:             
                             cmp   al,80                       ;W UP
                             jne   upPlayer2
   
                             cmp   y2,7
                             jnz   down2
                             jmp   PlayerMovmentExit
    down2:                   
                             mov   al,x2
                             mov   ah,y2
                             mov   prevX,al
                             mov   prevY,ah
                             inc   y2
                             inc   ah
                             mov   Column,al
                             mov   Row,ah
                             mov   Colour,highlight2
                             call  drawHilightPlayer
                             jmp   PlayerMovmentExit

    upPlayer2:               

                             cmp   al,72                       ;W UP
                             jne   rightPlayer2
                             cmp   y2,0
                             jnz   up2
                             jmp   PlayerMovmentExit
    up2:                     
                             mov   al,x2
                             mov   ah,y2
                             mov   prevX,al
                             mov   prevY,ah
                             dec   y2
                             dec   ah
                             mov   Column,al
                             mov   Row,ah
                             jmp   drawHighlight

    rightPlayer2:            
                             cmp   al,77                       ;W UP
                             jne   leftPlayer2
                             cmp   x2,7
                             jnz   right2
                             jmp   PlayerMovmentExit
    right2:                  
                             mov   al,x2
                             mov   ah,y2
                             mov   prevX,al
                             mov   prevY,ah
                             inc   x2
                             inc   al
                             mov   Column,al
                             mov   Row,ah
                             jmp   drawHighlight

    leftPlayer2:             
                             cmp   al,75                       ;W UP
                             jne   PlayerMovmentExit
                             cmp   x2,0
                             jnz   left2
                             jmp   PlayerMovmentExit
    left2:                   
                             mov   al,x2
                             mov   ah,y2
                             mov   prevX,al
                             mov   prevY,ah
                             dec   x2
                             dec   al
                             mov   Column,al
                             mov   Row,ah
                            
    drawHighlight:           
                             call  drawHilightPlayer
                      


    PlayerMovmentExit:       
                             popa
                             ret
PlayerMovment ENDP


SetHighlightPlayer1Board PROC FAR
                             pusha
                             mov   al,Row
                             mov   ah ,8
                             mul   ah                          ;row is in al
                             mov   ah,0
                             add   al,Column
                             mov   bx,ax
                             mov   player1Board[bx],1          ; now piece is in ah
                             popa
                             ret
SetHighlightPlayer1Board ENDP


SetHighlightPlayer2Board PROC FAR
                             pusha
                             mov   al,Row
                             mov   ah ,8
                             mul   ah                          ;row is in al
                             mov   ah,0
                             add   al,Column
                             mov   bx,ax
                             mov   player2Board[bx],1          ; now piece is in ah
                             popa
                             ret
SetHighlightPlayer2Board ENDP



    ;*******************************************Mustafa**************************************************;
GetPieceColour PROC FAR
                             pusha
                      
                             MOV   AH,0
                             MOV   AL,piece
                             MOV   BL,10
                             DIV   BL
                             MOV   PieceColour,AL

                             popa
                             ret
GetPieceColour ENDP



HighlightCell PROC FAR
                             pusha
    ;  CMP   playerColour,1
    ;  JNZ   HighlightCMP
    ;  CMP   CurrHighlight,movmentHighlight1
    ;  JNZ   HighlightCMP
                             CALL  getPieceBoard
                             MOV   AL, CurrHighlight
                             MOV   Colour,AL
                             call  DrawCell
                      
                             CMP   piece,0
                             JZ    HighlightCMP
                                                    
                             CALL  drawPiece                   ;PieceFound

    HighlightCMP:            MOV   AL,movmentHighlight2
                             CMP   CurrHighlight,AL
                             JZ    CurrBlackHighlight
                             CALL  SetHighlightPlayer1Board
                             JMP   HighlightExit

    CurrBlackHighlight:      CALL  SetHighlightPlayer2Board

    HighlightExit:           
                             popa
                             ret
HighlightCell ENDP




WhitePawnMovment PROC FAR
                             pusha
    ;Checking White for Player1
                             MOV   AL, x1
                             MOV   AH ,y1
                             MOV   Row,AH
                             MOV   Column,AL
                             CALL  getPieceBoard
                             CMP   piece,11
                             JNZ   WhitePawnTempExit
                             JMP   WhitePawnContinue

    WhitePawnTempExit:       JMP   WhitePawnExit

    WhitePawnContinue:       MOV   AL,x1
                             MOV   AH, y1
                             MOV   Row,AH
                             MOV   Column,AL

                             CMP   Row,6
                             JZ    WhitePawnTwoMoves

    WhitePawnOneMove:        
    ;Check if  the row = 0
                             CMP   Row,0
                             JZ    WhitePawnTempExit
                             DEC   Row
    ;Check if there is a piece in front of the pawn with same colour
                             CALL  getPieceBoard
                             CMP   piece, 0
                             JNZ   Hwhitepawncell1
                             MOV   AL,movmentHighlight1
                             MOV   CurrHighlight,AL
                             CALL  HighlightCell
                             JMP   Hwhitepawncell1

    WhitePawnTwoMoves:       
    ;Check if  the row = 0
                             CMP   Row,0
                             JZ    WhitePawnTempExit
                             DEC   Row
    ;Check if there is a piece in front of the pawn with same colour
                             CALL  getPieceBoard
                             CMP   piece, 0
                             JNZ   Hwhitepawncell1
                             MOV   AL,movmentHighlight1
                             MOV   CurrHighlight,AL
                             CALL  HighlightCell

    ;Check if  the row = 0
                             CMP   Row,0
                             JZ    WhitePawnTempExit
                             DEC   Row
    ;Check if there is a piece in front of the pawn with same colour
                             CALL  getPieceBoard
                             CMP   piece, 0
                             JNZ   Hwhitepawncell1
                             MOV   AL,movmentHighlight1
                             MOV   CurrHighlight,AL
                             CALL  HighlightCell
                            

   
    Hwhitepawncell1:         
    ;Check if  the Column = 0
                            
                             MOV   AL,x1
                             MOV   AH, y1
                             MOV   Row,AH
                             MOV   Column,AL
                             
                             CMP   Column,7
                             JZ    Hwhitepawncell2
                             CMP   Row,0
                             JZ    Hwhitepawncell2             ; UP RIGHT KILL
                             DEC   Row
                             INC   Column
                             CALL  getPieceBoard
                             CMP   piece, 0
                             JZ    Hwhitepawncell2
                             CALL  GetPieceColour
                             CMP   PieceColour,0
                             JNZ   Hwhitepawncell2
                             CALL  HighlightCell


    Hwhitepawncell2:         MOV   AL,x1
                             MOV   AH, y1
                             MOV   Row,AH
                             MOV   Column,AL
                             CMP   Column,0
                             JZ    WhitePawnExit
                             CMP   Row,0
                             JZ    WhitePawnExit               ; DOWN LEFT KILL
                             DEC   Row
                             DEC   Column
                             
                            
                             CALL  getPieceBoard
                             CMP   piece, 0
                             JZ    WhitePawnExit
                             CALL  GetPieceColour
                             CMP   PieceColour,0
                             JNZ   WhitePawnExit
                             CALL  HighlightCell

    WhitePawnExit:           
                             popa
                             RET
WhitePawnMovment ENDP




BlackPawnMovment PROC FAR
                             pusha
    ;Checking Black for Player2
                             MOV   AL, x2
                             MOV   AH ,y2
                             MOV   Row,AH
                             MOV   Column,AL
                             CALL  getPieceBoard
                             CMP   piece,01
                             JNZ   BlackPawnTempExit
                             JMP   BlackPawnContinue

    BlackPawnTempExit:       JMP   BlackPawnExit

    BlackPawnContinue:       
                             MOV   AL,x2
                             MOV   AH, y2
                             MOV   Row,AH
                             MOV   Column,AL
                      
                             CMP   Row,1
                             JZ    BlackPawnTwoMoves

    BlackPawnOneMove:        
    ;Check if  the row = 7
                             CMP   Row,7
                             JZ    BlackPawnTempExit
                             INC   Row
    ;Check if there is a piece in front of the pawn with same colour
                             CALL  getPieceBoard
                             CMP   piece, 0
                             JNZ   Hblackpawncell1
                             MOV   AL,movmentHighlight2
                             MOV   CurrHighlight,AL
                             CALL  HighlightCell
                             JMP   Hblackpawncell1

    BlackPawnTwoMoves:       
    ;Check if  the row = 7
                             CMP   Row,7
                             JZ    BlackPawnTempExit
                             INC   Row
    ;Check if there is a piece in front of the pawn with same colour
                             CALL  getPieceBoard
                             CMP   piece, 0
                             JNZ   Hblackpawncell1
                             MOV   AL,movmentHighlight2
                             MOV   CurrHighlight,AL
                             CALL  HighlightCell
    ;Check if  the row = 7
                             CMP   Row,7
                             JZ    BlackPawnTempExit
                             INC   Row
    ;Check if there is a piece in front of the pawn with same colour
                             CALL  getPieceBoard
                             CMP   piece, 0
                             JNZ   Hblackpawncell1
                             MOV   AL,movmentHighlight2
                             MOV   CurrHighlight,AL
                             CALL  HighlightCell


   
    Hblackpawncell1:         
    ;Check if  the Column = 7
                             CMP   Column,7
                             JZ    Hblackpawncell2

                             MOV   AL,x2
                             MOV   AH, y2
                             MOV   Row,AH
                             MOV   Column,AL
                             CMP   Row,7
                             JZ    Hblackpawncell2
                             CMP   Column,7
                             JZ    Hblackpawncell2
                             INC   Row
                             INC   Column                      ; DOWN RIGHT KILL
                             CALL  getPieceBoard
                             CMP   piece, 0
                             JZ    Hblackpawncell2
                             CALL  GetPieceColour
                             CMP   PieceColour,1
                             JNZ   Hblackpawncell2
                             CALL  HighlightCell


    Hblackpawncell2:         MOV   AL,x2
                             MOV   AH, y2
                             MOV   Row,AH
                             MOV   Column,AL
                             CMP   Row,7
                             JZ    BlackPawnExit
                             CMP   Column,0
                             JZ    BlackPawnExit
                             INC   Row
                             DEC   Column                      ; DOWN LEFT KILL
                             CALL  getPieceBoard
                             CMP   piece, 0
                             JZ    BlackPawnExit
                             CALL  GetPieceColour
                             CMP   PieceColour,1
                             JNZ   BlackPawnExit
                             CALL  HighlightCell
                             

    BlackPawnExit:           
                             popa
                             RET
BlackPawnMovment ENDP



WhitekingMovment proc FAR
                             pusha
    

    ;checks it's a king
                             mov   al,x1
                             mov   ah,y1
                             mov   Column,al
                             mov   row,ah
                             call  getPieceBoard
                             cmp   piece,16
                             jnz   kingRetW


                             lea   di,player1Board
                             mov   bx,7
    kingLpW:                 
                             mov   al,x1                       ;column
                             mov   ah,y1                       ;row
                             add   al,dxKing[bx]               ;adding dx and checking if it's vailid like c++
    ;if not valid just decremnt and loop again
                             cmp   al,0
                             jl    kingLpWEnd
                             cmp   al,7
                             jg    kingLpWEnd
                             add   ah,dyKing[bx]
                             cmp   ah,0
                             jl    kingLpWEnd
                             cmp   ah,7
                             jg    kingLpWEnd
   
    ;checking if the piece is my same colour
                             mov   Column,al
                             mov   row,ah
                             call  getPieceBoard               ; gets piece and then checks if it's the same colour as me
                             call  pieceType
                             cmp   piece,8
                             jg    kingLpWEnd

                             push  bx
                             mov   bl,diff
                             mov   bh,0
                             mov   player1Board[bx],1
                             pop   bx
    ;draw intersection



    ;draw no intersectiono

                             mov   Colour,movmentHighlight1
                             call  DrawCell
                             cmp   piece,0
                             jz    kingLpWEnd
                             call  drawPiece

    kingLpWEnd:              
                             dec   bx
                             cmp   bx,-1
                             jnz   kingLpW
    
    kingRetW:                
                             popa
                             ret
                             endp  WhitekingMovment





BlackkingMovment proc FAR
                             pusha
    

    ;checks it's a king
                             mov   al,x2
                             mov   ah,y2
                             mov   Column,al
                             mov   row,ah
                             call  getPieceBoard
                             cmp   piece,06
                             jnz   kingRetB


                             lea   di,player2Board
                             mov   bx,7
    kingLpB:                 
                             mov   al,x2                       ;column
                             mov   ah,y2                       ;row
                             add   al,dxKing[bx]               ;adding dx and checking if it's vailid like c++
    ;if not valid just decremnt and loop again
                             cmp   al,0
                             jl    kingLpBEnd
                             cmp   al,7
                             jg    kingLpBEnd
                             add   ah,dyKing[bx]
                             cmp   ah,0
                             jl    kingLpBEnd
                             cmp   ah,7
                             jg    kingLpBEnd
   
    ;checking if the piece is my same colour
                             mov   Column,al
                             mov   row,ah
                             call  getPieceBoard               ; gets piece and then checks if it's the same colour as me
                             call  pieceType
                             cmp   piece,8
                             jg    contKingBLack
                             cmp   piece,0
                             jz    contKingBLack
                             jmp   kingLpBEnd
    contKingBLack:           
                             push  bx
                             mov   bl,diff
                             mov   bh,0
                             mov   player2Board[bx],1
                             pop   bx
    
                             mov   Colour,movmentHighlight2
                             call  DrawCell
                             cmp   piece,0
                             jz    kingLpBEnd
                             call  drawPiece

    kingLpBEnd:              
                             dec   bx
                             cmp   bx,-1
                             jnz   kingLpB
    
    kingRetB:                
                             popa
                             ret
                             endp  BlackkingMovment




    ;*******************************************Yasser**************************************************;
WhiteRockMovment proc far
                             pusha
    ;Checking White piece
                             MOV   AL, x1
                             MOV   AH ,y1
                             MOV   Row,AH
                             MOV   Column,AL
                             CALL  getPieceBoard
                             cmp   piece,15
                             jz    queen
                             CMP   piece,12
                             JNZ   WhiteRockExit1
    queen:                   
    ;Highlight Up until reaching a piece
                             MOV   AL,x1
                             MOV   AH, y1
                             MOV   Row,AH
                             MOV   Column,AL
    UpLoop:                  DEC   Row
                             MOV   AL,movmentHighlight1
                             MOV   CurrHighlight,AL
                             CALL  getPieceBoard
                      
                             cmp   Row,0
                             js    upExit
                             cmp   piece,00
                             jne   uplast
                             CALL  HighlightCell
                             jmp   UpLoop
    ;highlight the next cell if it is black  "to kill"
    uplast:                  
                             call  GetPieceColour
                             cmp   PieceColour,1
                             je    upExit
                             call  HighlightCell
                             call  drawPiece
                             jmp   upExit
    WhiteRockExit1:          jmp   WhiteRockExit2
    ;Highlight Down until reaching a piece
    upExit:                  
                             MOV   AL,x1
                             MOV   AH, y1
                             MOV   Row,AH
                             MOV   Column,AL
    DownLoop:                inc   Row
                             MOV   AL,movmentHighlight1
                             MOV   CurrHighlight,AL
                             CALL  getPieceBoard
                             cmp   Row,7
                             jg    downExit
                             cmp   piece,00
                             jne   downlast
                             CALL  HighlightCell
                             jmp   DownLoop
    ;highlight the next cell if it is black  "to kill"
    downlast:                
                             call  GetPieceColour
                             cmp   PieceColour,1
                             je    downExit
                             call  HighlightCell
                             jmp   downExit
    WhiteRockExit2:          jmp   WhiteRockExit
    downExit:                
                             MOV   AL,x1
                             MOV   AH, y1
                             MOV   Row,AH
                             MOV   Column,AL
    RightLoop:               inc   Column
                             MOV   AL,movmentHighlight1
                             MOV   CurrHighlight,AL
                             CALL  getPieceBoard
                             cmp   Column,7
                             jg    rightExit
                             cmp   piece,00
                             jne   rightlast
                             CALL  HighlightCell
                             jmp   RightLoop
    ;highlight the next cell if it is black  "to kill"
    rightlast:               
                             call  GetPieceColour
                             cmp   PieceColour,1
                             je    rightExit
                             call  HighlightCell

    rightExit:               
                             MOV   AL,x1
                             MOV   AH, y1
                             MOV   Row,AH
                             MOV   Column,AL
    LeftLoop:                dec   Column
                             MOV   AL,movmentHighlight1
                             MOV   CurrHighlight,AL
                             CALL  getPieceBoard
                             cmp   Column,0
                             js    WhiteRockExit
                             cmp   piece,00
                             jne   leftlast
                             CALL  HighlightCell
                             jmp   LeftLoop
    ;highlight the next cell if it is black  "to kill"
    leftlast:                
                             call  GetPieceColour
                             cmp   PieceColour,1
                             je    WhiteRockExit
                             call  HighlightCell
    WhiteRockExit:           popa
                             ret

WhiteRockMovment endp

BlackRockMovment proc far
                             pusha
    ;Checking Black Piece
                             MOV   AL, x2
                             MOV   AH ,y2
                             MOV   Row,AH
                             MOV   Column,AL
                             CALL  getPieceBoard
                             cmp   piece,05
                             jz    queen3
                             CMP   piece,02
                             JNZ   BlackRockExit1
    queen3:                  
    ;Highlight Up until reaching a piece
                             MOV   AL, x2
                             MOV   AH ,y2
                             MOV   Row,AH
                             MOV   Column,AL
    UpLoop2:                 DEC   Row
                             MOV   AL,movmentHighlight2
                             MOV   CurrHighlight,AL
                             CALL  getPieceBoard
                      
                             cmp   Row,0
                             js    upExit2
                             cmp   piece,00
                             jne   uplast2
                             CALL  HighlightCell
                             jmp   UpLoop2
    ;highlight the next cell if it is white  "to kill"
    uplast2:                 
                             call  GetPieceColour
                             cmp   PieceColour,0
                             je    upExit2
                             call  HighlightCell
                             jmp   upExit2
    BlackRockExit1:          jmp   BlackRockExit2
    ;Highlight Down
    upExit2:                 
                             MOV   AL, x2
                             MOV   AH ,y2
                             MOV   Row,AH
                             MOV   Column,AL
    DownLoop2:               inc   Row
                             MOV   AL,movmentHighlight2
                             MOV   CurrHighlight,AL
                             CALL  getPieceBoard
                      
                             cmp   Row,7
                             jg    downExit2
                             cmp   piece,00
                             jne   downlast2
                             CALL  HighlightCell
                             jmp   DownLoop2
    ;highlight the next cell if it is white  "to kill"
    downlast2:               
                             call  GetPieceColour
                             cmp   PieceColour,0
                             je    downExit2
                             call  HighlightCell
                             jmp   downExit2
    BlackRockExit2:          jmp   BlackRockExit
    downExit2:               
                             MOV   AL, x2
                             MOV   AH ,y2
                             MOV   Row,AH
                             MOV   Column,AL
    RightLoop2:              inc   Column
                             MOV   AL,movmentHighlight2
                             MOV   CurrHighlight,AL
                             CALL  getPieceBoard
                      
                             cmp   Column,7
                             jg    rightExit2
                             cmp   piece,00
                             jne   rightlast2
                             CALL  HighlightCell
                             jmp   RightLoop2
    ;highlight the next cell if it is white  "to kill"
    rightlast2:              
                             call  GetPieceColour
                             cmp   PieceColour,0
                             je    rightExit2
                             call  HighlightCell
    rightExit2:              
                             MOV   AL,x2
                             MOV   AH, y2
                             MOV   Row,AH
                             MOV   Column,AL
    LeftLoop2:               dec   Column
                             MOV   AL,movmentHighlight2
                             MOV   CurrHighlight,AL
                             CALL  getPieceBoard
                     
                             cmp   Column,0
                             js    BlackRockExit
                             cmp   piece,00
                             jne   leftlast2
                             CALL  HighlightCell
                             jmp   LeftLoop2
    ;highlight the next cell if it is white  "to kill"
    leftlast2:               
                             call  GetPieceColour
                             cmp   PieceColour,0
                             je    BlackRockExit
                             call  HighlightCell
    BlackRockExit:           popa
                             ret
BlackRockMovment endp





    ;*******************************************Daniel**************************************************;

WhiteBishopMovement proc Far
                             pusha
                             MOV   AL, x1
                             MOV   AH ,y1
                             MOV   Row,AH
                             MOV   Column,AL
                             CALL  getPieceBoard
                             cmp   piece,15
                             jz    queen1
                             CMP   piece,14
                             JNZ   WhiteBishopexit1

    queen1:                  
                             jmp   tocomplete
    WhiteBishopexit1:                                          ; for far jump
                             jmp   WhiteBishopexit
    tocomplete:              
    upleft:                                                    ; loop for up left moves
                             cmp   Row,0
                             jz    exitupleft
                             cmp   Column,0
                             jz    exitupleft
                             dec   Row
                             dec   Column
                             call  getPieceBoard
                             cmp   piece,0
                             jz    emptycellupleft
                             cmp   piece,10
                             jb    killpieceupleft
                             jmp   exitupleft
    killpieceupleft:         
                             call  HighlightCell
                             call  drawPiece
                             jmp   exitupleft
    emptycellupleft:                                           ; if next up left cell is empty
                             MOV   dh,movmentHighlight1
                             MOV   CurrHighlight,dh
                             CALL  HighlightCell
                             jmp   upleft
    exitupleft:                                                ; exit from up left  to begin in up right
                             MOV   Row,AH                      ; begin up right loop
                             MOV   Column,AL
    upright:                 
                             cmp   Row,0
                             jz    exitupright
                             cmp   Column,7
                             jz    exitupright
                             dec   Row
                             inc   Column
                             call  getPieceBoard
                             cmp   piece,0
                             jz    emptycellupright
                             cmp   piece,10                    ; to check if there a black piece
                             jb    killpieceupright
                             jmp   exitupright
    killpieceupright:                                          ; move one more step and exit from loop
                             call  HighlightCell
                             call  drawPiece
                             jmp   exitupright
    emptycellupright:        
                             CALL  HighlightCell
                             jmp   upright
    exitupright:             
    ; begin downleft loop
                             MOV   Row,AH
                             MOV   Column,AL
    downleft:                
                             cmp   Row,7
                             jz    exitdownleft
                             cmp   Column,0
                             jz    exitdownleft
                             inc   Row
                             dec   Column
                             call  getPieceBoard
                             cmp   piece,0
                             jz    emptycelldownleft
                             cmp   piece,10                    ; to check if there a black piece
                             jb    killpiecedownleft
                             jmp   exitdownleft
    killpiecedownleft:       
                             call  HighlightCell
                             call  drawPiece
                             jmp   exitdownleft
    emptycelldownleft:       
                             CALL  HighlightCell
                             jmp   downleft
    exitdownleft:                                              ; begin down right loop
                             MOV   Row,AH
                             MOV   Column,AL
    downright:               
                             cmp   Row,7
                             jz    exitdownright
                             cmp   Column,7
                             jz    exitdownright
                             inc   Row
                             inc   Column
                             call  getPieceBoard
                             cmp   piece,0
                             jz    emptycelldownright
                             cmp   piece,10                    ; to check if there a black piece
                             jb    killpiecedownright
                             jmp   exitdownright
    killpiecedownright:      
                             call  HighlightCell
                             call  drawPiece
                             jmp   exitdownright
    emptycelldownright:      
                             MOV   dh,movmentHighlight1
                             MOV   CurrHighlight,dh
                             CALL  HighlightCell
                             jmp   downright
    exitdownright:           
    WhiteBishopexit:         
                             popa
                             ret
                             endp  WhiteBishopMovement





BlackBishopMovement proc Far
                             pusha
                             MOV   AL, x2
                             MOV   AH ,y2
                             MOV   Row,AH
                             MOV   Column,AL
                             CALL  getPieceBoard
                             cmp   piece,05
                             jz    queen2
                             CMP   piece,04
                             JNZ   BlackBishopexit1

    queen2:                  jmp   tocompleteB
    blackBishopexit1:                                          ; for far jump
                             jmp   BlackBishopexit
    tocompleteB:             
    upleftB:                                                   ; loop for up left moves
                             cmp   Row,0
                             jz    exitupleftB
                             cmp   Column,0
                             jz    exitupleftB
                             dec   Row
                             dec   Column
                             call  getPieceBoard
                             cmp   piece,0
                             jz    emptycellupleftB
                             cmp   piece,10
                             ja    killpieceupleftB
                             jmp   exitupleftB
    killpieceupleftB:        
                             call  HighlightCell
                             call  drawPiece
                             jmp   exitupleftB
    emptycellupleftB:                                          ; if next up left cell is empty
                             MOV   dh,movmentHighlight2
                             MOV   CurrHighlight,dh
                             CALL  HighlightCell
                             jmp   upleftB
    exitupleftB:                                               ; exit from up left  to begin in up right
                             MOV   Row,AH                      ; begin up right loop
                             MOV   Column,AL
    uprightB:                
                             cmp   Row,0
                             jz    exituprightB
                             cmp   Column,7
                             jz    exituprightB
                             dec   Row
                             inc   Column
                             call  getPieceBoard
                             cmp   piece,0
                             jz    emptycelluprightB
                             cmp   piece,10                    ; to check if there a black piece
                             ja    killpieceuprightB
                             jmp   exituprightB
    killpieceuprightB:                                         ; move one more step and exit from loop
                             call  HighlightCell
                             call  drawPiece
                             jmp   exituprightB
    emptycelluprightB:       
                             CALL  HighlightCell
                             jmp   uprightB
    exituprightB:            
    ; begin downleft loop
                             MOV   Row,AH
                             MOV   Column,AL
    downleftB:               
                             cmp   Row,7
                             jz    exitdownleftB
                             cmp   Column,0
                             jz    exitdownleftB
                             inc   Row
                             dec   Column
                             call  getPieceBoard
                             cmp   piece,0
                             jz    emptycelldownleftB
                             cmp   piece,10                    ; to check if there a black piece
                             ja    killpiecedownleftB
                             jmp   exitdownleftB
    killpiecedownleftB:      
                             call  HighlightCell
                             call  drawPiece
                             jmp   exitdownleftB
    emptycelldownleftB:      
                             CALL  HighlightCell
                             jmp   downleftB
    exitdownleftB:                                             ; begin down right loop
                             MOV   Row,AH
                             MOV   Column,AL
    downrightB:              
                             cmp   Row,7
                             jz    exitdownrightB
                             cmp   Column,7
                             jz    exitdownrightB
                             inc   Row
                             inc   Column
                             call  getPieceBoard
                             cmp   piece,0
                             jz    emptycelldownrightB
                             cmp   piece,10                    ; to check if there a black piece
                             ja    killpiecedownrightB
                             jmp   exitdownrightB
    killpiecedownrightB:     
                             call  HighlightCell
                             call  drawPiece
                             jmp   exitdownrightB
    emptycelldownrightB:     
                             CALL  HighlightCell
                             jmp   downrightB
    exitdownrightB:          
    BlackBishopexit:         
                             popa
                             ret
                             endp  BlackBishopMovement







    ;**************allam****************


WhiteknightMovment proc FAR
                             pusha
    

    ;checks it's a knight
                             mov   al,x1
                             mov   ah,y1
                             mov   Column,al
                             mov   row,ah
                             call  getPieceBoard
                             cmp   piece,13
                             jnz   knightRetW


                             lea   di,player1Board
                             mov   bx,7
    knightLpW:               
                             mov   al,x1                       ;column
                             mov   ah,y1                       ;row
                             add   al,dxKnight[bx]             ;adding dx and checking if it's vailid like c++
    ;if not valid just decremnt and loop again
                             cmp   al,0
                             jl    knightLpWEnd
                             cmp   al,7
                             jg    knightLpWEnd
                             add   ah,dyKnight[bx]
                             cmp   ah,0
                             jl    knightLpWEnd
                             cmp   ah,7
                             jg    knightLpWEnd
   
    ;checking if the piece is my same colour
                             mov   Column,al
                             mov   row,ah
                             call  getPieceBoard               ; gets piece and then checks if it's the same colour as me
                             call  pieceType
                             cmp   piece,8
                             jg    knightLpWEnd

                             push  bx
                             mov   bl,diff
                             mov   bh,0
                             mov   player1Board[bx],1
                             pop   bx
    ;draw intersection



    ;draw no intersectiono

                             mov   Colour,movmentHighlight1
                             call  DrawCell
                             cmp   piece,0
                             jz    knightLpWEnd
                             call  drawPiece

    knightLpWEnd:            
                             dec   bx
                             cmp   bx,-1
                             jnz   knightLpW
    
    knightRetW:              
                             popa
                             ret
                             endp  WhiteknightMovment


BlackknightMovment proc FAR
                             pusha
    

    ;checks it's a knight
                             mov   al,x2
                             mov   ah,y2
                             mov   Column,al
                             mov   row,ah
                             call  getPieceBoard
                             cmp   piece,03
                             jnz   knightRetB
    
   


                             lea   di,player2Board
                             mov   bx,7
    knightLpB:               
                             mov   al,x2                       ;column
                             mov   ah,y2                       ;row
                             add   al,dxKnight[bx]             ;adding dx and checking if it's vailid like c++
    ;if not valid just decremnt and loop again
                             cmp   al,0
                             jl    knightLpBEnd
                             cmp   al,7
                             jg    knightLpBEnd
                             add   ah,dyKnight[bx]
                             cmp   ah,0
                             jl    knightLpBEnd
                             cmp   ah,7
                             jg    knightLpBEnd
   
    ;checking if the piece is my same colour
                             mov   Column,al
                             mov   row,ah
                             call  getPieceBoard               ; gets piece and then checks if it's the same colour as me
                             call  pieceType
                             cmp   piece,0
                             jz    contBlackKnight
                             cmp   piece,8
                             jl    knightLpBEnd

    contBlackKnight:         
                             push  bx
                             mov   bl,diff
                             mov   bh,0
                             mov   player2Board[bx],1
                             pop   bx
    ;draw intersection



    ;draw no intersectiono

                             mov   Colour,movmentHighlight2
                             call  DrawCell
                             cmp   piece,0
                             jz    knightLpBEnd
                             call  drawPiece

    knightLpBEnd:            
                             dec   bx
                             cmp   bx,-1
                             jnz   knightLpB
    
    knightRetB:              
                             popa
                             ret
                             endp  BlackknightMovment



checkEmptyCell proc Far                                        ;takes row and column and gives you colour of the cell (p1->p2->highlight2->normal Cell)
    ;otherBoardHighlight should be set also (very important)
                             pusha
                             mov   al,Column                   ;setting column and row for draw cell later
                             mov   ah,Row
                             cmp   x1,al                       ;check if player one is on that cell
                             jnz   p2
                             cmp   y1,ah
                             jnz   p2
                             mov   bl,highlight1               ;puts the first player movment highlight in colour and goes to draw it
                             mov   Colour,bl
                             jmp   clrDraw

    p2:                      
                             cmp   x2,al                       ;check if player two is on that cell
                             jnz   highlightP2
                             cmp   y2,ah
                             jnz   highlightP2
                             mov   bl,highlight2               ;now we know player two is there just put hish colour in colour and go draw it
                             mov   Colour,bl
                             jmp   clrDraw

    highlightP2:             
                             mov   bl,[si]
                             cmp   bl,1                        ;checking if the other player's board has a highlight on this cell or not
                             jnz   normalCell
                             mov   bl,otherBoardColour
                             mov   Colour,bl
                             jmp   clrDraw


    normalCell:              
                             call  GetColour                   ;if there's no player or highlight on that cell get it's normal colour and draw it

    clrDraw:                                                   ;draws the cell here after it has the correct colour
                             popa
                             ret
                             endp  checkEmptyCell

clearBoardHighlight proc FAR                                   ;clears highlighted cells for the player
    ; the player's board is in di
    ;other player's board is si
                             pusha

                             mov   cx,64                       ;loop iterator
    
                             mov   al,0                        ;column
                             mov   ah,0                        ; row
    
    clrLoop:                 
                             mov   bl,[di]
                             cmp   bl,1
                             jnz   clrEnd                      ;if the current cell doesn't have anything continue
                             mov   bl,0
                             mov   [di],bl                     ;clear highlight



                             mov   Column,al                   ;setting column and row for draw cell later
                             mov   row,ah

                             call  checkEmptyCell

                             call  DrawCell
                             call  getPieceBoard
                             cmp   piece,0
                             jz    clrEnd
                             call  drawPiece
    clrEnd:                  
                             inc   di                          ;incremeting through the first and the second board
                             inc   si

                             inc   al                          ;increasing the al(column) and ah(row) to keep track of where i am on the board
    ; useful later for drawing when using row and column
                             cmp   al,8
                             jnz   lpEnd
                             mov   al,0
                             inc   ah
    lpEnd:                   
                             loop  clrLoop




                             popa
                             ret
                             endp  clearBoardHighlight


    ;**************allamEnd****************



WhiteQueenMovment PROC FAR
                             CALL  WhiteBishopMovement
                             CALL  WhiteRockMovment
                             ret
WhiteQueenMovment ENDP

BlackQueenMovment PROC FAR
                             CALL  BlackBishopMovement
                             CALL  BlackRockMovment
                             ret
BlackQueenMovment ENDP


StatusBarWhite PROC FAR
                             pusha

                             mov   al,piece

    ; black pieces

                             cmp   al,01
                             mov   pieceicon,'P'
                             jz    endType1

                             cmp   al,02
                             mov   pieceicon,'R'
                             jz    endType1

                             cmp   al,03
                             mov   pieceicon,'H'
                             jz    endType1

                             cmp   al,04
                             mov   pieceicon,'B'
                             jz    endType1

                             cmp   al,05
                             mov   pieceicon,'Q'
                             jz    endType1

                             cmp   al,06
                             mov   pieceicon,'K'
                             jz    endType1

    endType1:                


                             mov   dl, statusbarColumn1        ;Column
                             mov   dh, statusbarRow1           ;Row
                             mov   bh, 0                       ;Display page
                             mov   ah, 02h                     ;SetCursorPosition
                             int   10h

                             mov   al, pieceicon
                             mov   bl, 51h                     ;Color is red
                             mov   bh, 0                       ;Display page
                             mov   ah, 0Eh                     ;Teletype
                             int   10h

                             INC   statusbarColumn1



    ;check if king is dead
                             cmp   piece,06
                             jz    whitekingdead
                             jmp   StatusBarWhiteExit
    whitekingdead:           mov   win,2


    StatusBarWhiteExit:      popa
                             ret
StatusBarWhite ENDP

StatusBarBlack PROC FAR
                             pusha
    ; white pieces
                             mov   al,piece

                             cmp   al,11
                             mov   pieceicon,'P'
                             jz    endType2

                             cmp   al,12
                             mov   pieceicon,'R'
                             jz    endType2

                             cmp   al,13
                             mov   pieceicon,'H'
                             jz    endType2

                             cmp   al,14
                             mov   pieceicon,'B'
                             jz    endType2

                             cmp   al,15
                             mov   pieceicon,'Q'
                             jz    endType2

                             cmp   al,16
                             mov   pieceicon,'K'
                             jz    endType2
        

    endType2:                
       
                             mov   dl, statusbarColumn2        ;Column
                             mov   dh, statusbarRow2           ;Row
                             mov   bh, 0                       ;Display page
                             mov   ah, 02h                     ;SetCursorPosition
                             int   10h

                             mov   al, pieceicon
                             mov   bl, 42h                     ;Color is red
                             mov   bh, 0                       ;Display page
                             mov   ah, 0Eh                     ;Teletype
                             int   10h


                             INC   statusbarColumn2

    ;check if king is dead
                             cmp   piece,16
                             jz    Blackkingdead
                             jmp   StatusBarBlackExit
    Blackkingdead:           mov   win,1



    StatusBarBlackExit:      popa
                             ret
StatusBarBlack ENDP



    ;*******************************************MAIN**************************************************;

    ;check algorithm: we check all possible directions for king and trace this directions to get the expected piece which may check the king
CheckWhiteRockQueen proc far
    ;loop for upper direction
                             pusha
                             MOV   AL, kx1
                             MOV   AH ,ky1
                             MOV   Row,AH
                             MOV   Column,AL
                         
    UpLoopk:                 DEC   Row
                             CALL  getPieceBoard
                             cmp   Row,0                       ;check if it is out of grid
                             js    FinishUpk
                             cmp   piece,02                    ;compare with black rock
                             je    upperk
                             cmp   piece,05                    ;compare with black queen
                             je    upperk
                             cmp   piece,0                     ;compare if it is empty cell
                             jne   FinishUpk
                             jmp   uprockk
    upperk:                  mov   check1,1                    ;activate check color "red" for white player
                             jmp   exitRockQueen
    uprockk:                 jmp   UpLoopk
                             jmp   FinishUpk
    upk:                     jmp   exitRockQueen
    ;loop for down direction
    FinishUpk:               MOV   AL, kx1
                             MOV   AH ,ky1
                             MOV   Row,AH
                             MOV   Column,AL
                         
    DownLoopk:               inc   Row
                             CALL  getPieceBoard
                             cmp   Row,7                       ;check if it is out of grid
                             jg    FinishDownk
                             cmp   piece,02                    ;compare with black rock
                             je    downk
                             cmp   piece,05                    ;compare with black queen
                             je    downk
                             cmp   piece,0                     ;compare if it is empty cell
                             jne   FinishDownk
                             jmp   downrockk
    downk:                   mov   check1,1                    ;activate check color "red" for white player
                             jmp   exitRockQueen
    downrockk:               jmp   DownLoopk
                               
                             jmp   FinishDownk
    downkk:                  jmp   exitRockQueen
    ;loop for right direction
    FinishDownk:             MOV   AL, kx1
                             MOV   AH ,ky1
                             MOV   Row,AH
                             MOV   Column,AL
                         
    RightLoopk:              inc   Column
                             CALL  getPieceBoard
                             cmp   Column,7                    ;check if it is out of grid
                             jg    FinishRightk
                             cmp   piece,02                    ;compare with black rock
                             je    Rightk
                             cmp   piece,05                    ;compare with black queen
                             je    Rightk
                             cmp   piece,0                     ;compare if it is empty cell
                             jne   FinishRightk
                             jmp   rightrockk
    Rightk:                  mov   check1,1                    ;activate check color "red" for white player
                             jmp   exitRockQueen
    rightrockk:              jmp   RightLoopk

                             jmp   FinishRightk
    rightkk:                 jmp   exitRockQueen
    ;loop for left direction
    FinishRightk:            MOV   AL, kx1
                             MOV   AH ,ky1
                             MOV   Row,AH
                             MOV   Column,AL
                         
    LeftLoopk:               DEC   Column
                             CALL  getPieceBoard
                             cmp   Column,0                    ;check if it is out of grid
                             js    exitRockQueen
                             cmp   piece,02                    ;compare with black rock
                             je    leftk
                             cmp   piece,05                    ;compare with black queen
                             je    leftk
                             cmp   piece,0                     ;compare if it is empty cell
                             jne   exitRockQueen
                             jmp   leftrockk
    leftk:                   mov   check1,1                    ;activate check color "red" for white player
                             jmp   exitRockQueen
    leftrockk:               jmp   LeftLoopk

    exitRockQueen:           popa
                             ret
CheckWhiteRockQueen endp


CheckBlackRockQueen proc far
    ;loop for upper direction
                             pusha
                             MOV   AL, kx2
                             MOV   AH ,ky2
                             MOV   Row,AH
                             MOV   Column,AL
                         
    UpLoopk2:                DEC   Row
                             CALL  getPieceBoard
                             cmp   Row,0                       ;check if it is out of grid
                             js    FinishUpk2
                             cmp   piece,12                    ;compare with white rock
                             je    upperk2
                             cmp   piece,15                    ;compare with white queen
                             je    upperk2
                             cmp   piece,0                     ;compare if it is empty cell
                             jne   FinishUpk2
                             jmp   uprockk2
    upperk2:                 mov   check2,1                    ;activate check color "red" for black player
                             jmp   exitRockQueen2
    uprockk2:                jmp   UpLoopk2
                             jmp   FinishUpk2
    upk2:                    jmp   exitRockQueen2
    ;loop for down direction
    FinishUpk2:              MOV   AL, kx2
                             MOV   AH ,ky2
                             MOV   Row,AH
                             MOV   Column,AL
                         
    DownLoopk2:              inc   Row
                             CALL  getPieceBoard
                             cmp   Row,7                       ;check if it is out of grid
                             jg    FinishDownk2
                             cmp   piece,12                    ;compare with white rock
                             je    downk2
                             cmp   piece,15                    ;compare with white queen
                             je    downk2
                             cmp   piece,0                     ;compare if it is empty cell
                             jne   FinishDownk2
                             jmp   downrockk2
    downk2:                  mov   check2,1                    ;activate check color "red" for black player
                             jmp   exitRockQueen
    downrockk2:              jmp   DownLoopk2
                               
                             jmp   FinishDownk2
    downkk2:                 jmp   exitRockQueen2
    ;loop for right direction
    FinishDownk2:            MOV   AL, kx2
                             MOV   AH ,ky2
                             MOV   Row,AH
                             MOV   Column,AL
                         
    RightLoopk2:             inc   Column
                             CALL  getPieceBoard
                             cmp   Column,7                    ;check if it is out of grid
                             jg    FinishRightk2
                             cmp   piece,12                    ;compare with white rock
                             je    Rightk2
                             cmp   piece,15                    ;compare with white queen
                             je    Rightk2
                             cmp   piece,0                     ;compare if it is empty cell
                             jne   FinishRightk2
                             jmp   rightrockk2
    Rightk2:                 mov   check2,1                    ;activate check color "red" for black player
                             jmp   exitRockQueen2
    rightrockk2:             jmp   RightLoopk2

                             jmp   FinishRightk2
    rightkk2:                jmp   exitRockQueen2
    ;loop for left direction
    FinishRightk2:           MOV   AL, kx2
                             MOV   AH ,ky2
                             MOV   Row,AH
                             MOV   Column,AL
                         
    LeftLoopk2:              DEC   Column
                             CALL  getPieceBoard
                             cmp   Column,0                    ;check if it is out of grid
                             js    exitRockQueen2
                             cmp   piece,12                    ;compare with white rock
                             je    leftk2
                             cmp   piece,15                    ;compare with white queen
                             je    leftk2
                             cmp   piece,0                     ;compare if it is empty cell
                             jne   exitRockQueen2
                             jmp   leftrockk2
    leftk2:                  mov   check2,1                    ;activate check color "red" for black player
                             jmp   exitRockQueen2
    leftrockk2:              jmp   LeftLoopk2

    exitRockQueen2:          popa
                             ret
CheckBlackRockQueen endp




CheckBlackBishop proc Far
                             pusha
                             
                        
                             MOV   AL, kx2
                             MOV   AH ,ky2
                             MOV   Row,AH
                             MOV   Column,AL
                        
    upleftBC:                                                  ; loop for up left moves
                             cmp   Row,0
                             jz    exitupleftBC
                             cmp   Column,0
                             jz    exitupleftBC
                             dec   Row
                             dec   Column
                             call  getPieceBoard
                             cmp   piece,14
                             jz    makecheckupleftB
                             cmp   piece,15
                             jz    makecheckupleftB
                             cmp   piece,00
                             jnz   exitupleftBC
                             jmp   upleftBC
    makecheckupleftB:        
                             mov   check2,1
    exitupleftBC:                                              ; exit from up left  to begin in up right
                             MOV   Row,AH                      ; begin up right loop
                             MOV   Column,AL
    uprightBC:               
                             cmp   Row,0
                             jz    exituprightBC
                             cmp   Column,7
                             jz    exituprightBC
                             dec   Row
                             inc   Column
                             call  getPieceBoard
                             cmp   piece,14
                             jz    makecheckuprightB
                             cmp   piece,15
                             jz    makecheckuprightB
                             cmp   piece,00
                             jnz   exituprightBC
                             jmp   uprightBC
    makecheckuprightB:       
                             mov   check2,1
                            
  
    exituprightBC:           
    ; begin downleft loop
                             MOV   Row,AH
                             MOV   Column,AL
    downleftBC:              
                             cmp   Row,7
                             jz    exitdownleftBC
                             cmp   Column,0
                             jz    exitdownleftBC
                             inc   Row
                             dec   Column
                             call  getPieceBoard
                             cmp   piece,14
                             jz    makecheckdownleftB
                             cmp   piece,15
                             jz    makecheckdownleftB
                             cmp   piece,00
                             jnz   exitdownleftBC
                             jmp   downleftBC
    makecheckdownleftB:      
                             mov   check2,1
                             
    exitdownleftBC:                                            ; begin down right loop
                             MOV   Row,AH
                             MOV   Column,AL
    downrightBC:             
                             cmp   Row,7
                             jz    exitdownrightBC
                             cmp   Column,7
                             jz    exitdownrightBC
                             inc   Row
                             inc   Column
                             call  getPieceBoard
                             cmp   piece,14
                             jz    makecheckdownrightB
                             cmp   piece,15
                             jz    makecheckdownrightB
                             cmp   piece,00
                             jnz   exitdownrightBC
                             jmp   downrightBC
    makecheckdownrightB:     
                             mov   check2,1
                             
    exitdownrightBC:         
                             popa
                             ret
CheckBlackBishop endp


CheckWhiteBishop PROC FAR
                             pusha
                        
                             MOV   AL, kx1
                             MOV   AH ,ky1
                             MOV   Row,AH
                             MOV   Column,AL
                        
    upleftC:                                                   ; loop for up left moves
                             cmp   Row,0
                             jz    exitupleftC
                             cmp   Column,0
                             jz    exitupleftC
                             dec   Row
                             dec   Column
                             call  getPieceBoard
                             cmp   piece,04
                             jz    makecheckupleft
                             cmp   piece,05
                             jz    makecheckupleft
                             cmp   piece,00
                             jnz   exitupleftC
                             jmp   upleftC
    makecheckupleft:         
                             mov   check1,1
    exitupleftC:                                               ; exit from up left  to begin in up right
                             MOV   Row,AH                      ; begin up right loop
                             MOV   Column,AL
    uprightC:                
                             cmp   Row,0
                             jz    exituprightC
                             cmp   Column,7
                             jz    exituprightC
                             dec   Row
                             inc   Column
                             call  getPieceBoard
                             cmp   piece,04
                             jz    makecheckupright
                             cmp   piece,05
                             jz    makecheckupright
                             cmp   piece,00
                             jnz   exituprightC
                             jmp   uprightC
    makecheckupright:        
                             mov   check1,1
                            
  
    exituprightC:            
    ; begin downleft loop
                             MOV   Row,AH
                             MOV   Column,AL
    downleftC:               
                             cmp   Row,7
                             jz    exitdownleftC
                             cmp   Column,0
                             jz    exitdownleftC
                             inc   Row
                             dec   Column
                             call  getPieceBoard
                             cmp   piece,04
                             jz    makecheckdownleft
                             cmp   piece,05
                             jz    makecheckdownleft
                             cmp   piece,00
                             jnz   exitdownleftC
                             jmp   downleftC
    makecheckdownleft:       
                             mov   check1,1
                             
    exitdownleftC:                                             ; begin down right loop
                             MOV   Row,AH
                             MOV   Column,AL
    downrightC:              
                             cmp   Row,7
                             jz    exitdownrightC
                             cmp   Column,7
                             jz    exitdownrightC
                             inc   Row
                             inc   Column
                             call  getPieceBoard
                             cmp   piece,04
                             jz    makecheckdownright
                             cmp   piece,05
                             jz    makecheckdownright
                             cmp   piece,00
                             jnz   exitdownrightC
                             jmp   downrightC
    makecheckdownright:      
                             mov   check1,1
                             
    exitdownrightC:          
                             popa
                             ret
CheckWhiteBishop endp


checkWhiteHorse proc FAR                                       ;checks for black horses
                             pusha
    

                             mov   bx,7


    knightLpWk:              
                             mov   al,kx1                      ;column
                             mov   ah,ky1                      ;row
                             add   al,dxKnight[bx]             ;adding dx and checking if it's vailid like c++
    ;if not valid just decremnt and loop again
                             cmp   al,0
                             jl    knightLpWEndk
                             cmp   al,7
                             jg    knightLpWEndk
                             add   ah,dyKnight[bx]
                             cmp   ah,0
                             jl    knightLpWEndk
                             cmp   ah,7
                             jg    knightLpWEndk
   
    ;checking if the piece is my same colour
                             mov   Column,al
                             mov   row,ah
                             call  getPieceBoard               ; gets piece and then checks if it's the same colour as me
                             call  pieceType
                             cmp   piece,03                    ;checking if it's black horse
                             jnz   knightLpWEndk
                             mov   check1,1
                             jmp   knightRetWk

    knightLpWEndk:           
                             dec   bx
                             cmp   bx,-1
                             jnz   knightLpWk
    
    knightRetWk:             
                             popa
                             ret
                             endp  checkWhiteHorse

checkBlackHorse proc FAR                                       ;checks for black horses
                             pusha
    

                             mov   bx,7


    knightLpBk:              
                             mov   al,kx2                      ;column
                             mov   ah,ky2                      ;row
                             add   al,dxKnight[bx]             ;adding dx and checking if it's vailid like c++
    ;if not valid just decremnt and loop again
                             cmp   al,0
                             jl    knightLpBEndk
                             cmp   al,7
                             jg    knightLpBEndk
                             add   ah,dyKnight[bx]
                             cmp   ah,0
                             jl    knightLpBEndk
                             cmp   ah,7
                             jg    knightLpBEndk
   
    ;checking if the piece is my same colour
                             mov   Column,al
                             mov   row,ah
                             call  getPieceBoard               ; gets piece and then checks if it's the same colour as me
                             call  pieceType
                             cmp   piece,13                    ;checking if it's black horse
                             jnz   knightLpBEndk
                             mov   check2,1
                             jmp   knightRetBk

    knightLpBEndk:           
                             dec   bx
                             cmp   bx,-1
                             jnz   knightLpBk
    
    knightRetBk:             
                             popa
                             ret
                             endp  checkBlackHorse

checkWhiteKingKill proc FAR                                    ;checks for black horses
                             pusha
    

                             mov   bx,7


    kingLpWk:                
                             mov   al,kx1                      ;column
                             mov   ah,ky1                      ;row
                             add   al,dxKing[bx]               ;adding dx and checking if it's vailid like c++
    ;if not valid just decremnt and loop again
                             cmp   al,0
                             jl    kingLpWEndk
                             cmp   al,7
                             jg    kingLpWEndk
                             add   ah,dyKing[bx]
                             cmp   ah,0
                             jl    kingLpWEndk
                             cmp   ah,7
                             jg    kingLpWEndk
   
    ;checking if the piece is my same colour
                             mov   Column,al
                             mov   row,ah
                             call  getPieceBoard               ; gets piece and then checks if it's the same colour as me
                             call  pieceType
                             cmp   piece,06                    ;checking if it's black horse
                             jnz   kingLpWEndk
                             mov   check1,1
                             jmp   kingRetWk

    kingLpWEndk:             
                             dec   bx
                             cmp   bx,-1
                             jnz   kingLpWk
    
    kingRetWk:               
                             popa
                             ret
                             endp  checkWhiteKingKill

                             
checkBlackKingKill proc FAR                                    ;checks for black horses
                             pusha
    

                             mov   bx,7


    kingLpBk:                
                             mov   al,kx2                      ;column
                             mov   ah,ky2                      ;row
                             add   al,dxKing[bx]               ;adding dx and checking if it's vailid like c++
    ;if not valid just decremnt and loop again
                             cmp   al,0
                             jl    kingLpBEndk
                             cmp   al,7
                             jg    kingLpBEndk
                             add   ah,dyKing[bx]
                             cmp   ah,0
                             jl    kingLpBEndk
                             cmp   ah,7
                             jg    kingLpBEndk
   
    ;checking if the piece is my same colour
                             mov   Column,al
                             mov   row,ah
                             call  getPieceBoard               ; gets piece and then checks if it's the same colour as me
                             call  pieceType
                             cmp   piece,16                    ;checking if it's black horse
                             jnz   kingLpBEndk
                             mov   check2,1
                             jmp   kingRetBk

    kingLpBEndk:             
                             dec   bx
                             cmp   bx,-1
                             jnz   kingLpBk
    
    kingRetBk:               
                             popa
                             ret
                             endp  checkBLackKingKill







CheckWhitePawn PROC FAR                                        ;pawn kill white king
                             pusha
                             MOV   AL,kx1
                             MOV   AH, ky1
                             MOV   Row,AH
                             MOV   Column,AL
                             CMP   Row,0
                             JZ    CheckWhitePawnHcell
                             CMP   Column,7
                             JZ    CheckWhitePawnHcell
                             DEC   Row
                             INC   Column                      ; DOWN RIGHT KILL
                             CALL  getPieceBoard
                             CMP   piece, 0
                             JZ    CheckWhitePawnHcell
                             CALL  getPieceBoard
                             CALL  GetPieceColour
                             CMP   PieceColour,0
                             JNZ   CheckWhitePawnHcell
                             CMP   piece,01
                             JZ    BlackPawnWillKill
                             JMP   CheckWhitePawnHcell
    BlackPawnWillKill:       MOV   check1,1


    CheckWhitePawnHcell:     MOV   AL,kx1
                             MOV   AH,ky1
                             MOV   Row,AH
                             MOV   Column,AL
                             CMP   Row,0
                             JZ    CheckWhitePawnExit
                             CMP   Column,0
                             JZ    CheckWhitePawnExit
                             DEC   Row
                             DEC   Column                      ; DOWN LEFT KILL
                             CALL  getPieceBoard
                             CMP   piece, 0
                             JZ    CheckWhitePawnExit
                             CALL  getPieceBoard
                             CALL  GetPieceColour
                             CMP   PieceColour,0
                             JNZ   CheckWhitePawnExit
                             CMP   piece,01
                             JZ    BlackPawnWillKill1
                             JMP   CheckWhitePawnExit
    BlackPawnWillKill1:      MOV   check1,1
                             
    CheckWhitePawnExit:      
                             popa
                             RET
CheckWhitePawn ENDP



CheckBlackPawn PROC FAR                                        ;pawn kill white king
                             pusha
                             MOV   AL,kx2
                             MOV   AH,ky2
                             MOV   Row,AH
                             MOV   Column,AL
                             CMP   Row,7
                             JZ    CheckBlackPawnHcell
                             CMP   Column,7
                             JZ    CheckBlackPawnHcell
                             INC   Row
                             INC   Column                      ; DOWN RIGHT KILL
                             CALL  getPieceBoard
                             CMP   piece,0
                             JZ    CheckBlackPawnHcell
                             CALL  getPieceBoard
                             CMP   piece,11
                             JZ    WhitePawnWillKill
                             JMP   CheckBlackPawnHcell
    WhitePawnWillKill:       MOV   check2,1


    CheckBlackPawnHcell:     MOV   AL,kx2
                             MOV   AH,ky2
                             MOV   Row,AH
                             MOV   Column,AL
                             CMP   Row,7
                             JZ    CheckBlackPawnExit
                             CMP   Column,0
                             JZ    CheckBlackPawnExit
                             INC   Row
                             DEC   Column                      ; DOWN LEFT KILL
                             CALL  getPieceBoard
                             CMP   piece, 0
                             JZ    CheckBlackPawnExit
                             CALL  getPieceBoard
                             CMP   piece,11
                             JZ    WhitePawnWillKill1
                             JMP   CheckBlackPawnExit
    WhitePawnWillKill1:      MOV   check2,1
                             
    CheckBlackPawnExit:      
                             popa
                             RET
CheckBlackPawn ENDP










checkWhiteKing proc FAR
                             pusha
    ;kx1,ky1
                             mov   check1,0
                             call  checkWhiteHorse
                             call  CheckWhiteBishop
                             call  CheckWhiteRockQueen
                             call  CheckWhitePawn
                             call  checkWhiteKingKill
                             mov   Row,7
                             mov   Column,12
                             cmp   check1,1
                             jnz   notChecked1

                             mov   colour,04                   ;red
                             jmp   endWhiteCheck
    notChecked1:             
                             mov   colour,0                    ;black

    endWhiteCheck:           
                             mov   StartPixel,61752
                             call  DrawCheckCell
                            
                             popa
                             ret
CheckWhiteKing ENDP


checkBlackKing proc FAR
                             pusha
    ;kx1,ky1
                             mov   check2,0
                             call  checkBlackHorse
                             call  CheckBlackPawn
                             call  CheckBlackBishop
                             call  checkBlackKingKill
                             call  CheckBlackRockQueen
                             
                             mov   Row,0
                             mov   Column,12
                             cmp   check2,1
                             jnz   notChecked2

                             mov   colour,04                   ;red
                             jmp   endBlackCheck
    notChecked2:             
                             mov   colour,0                    ;black

    endBlackCheck:           
                             mov   StartPixel, 29112
                             call  DrawCheckCell
                            
                             popa
                             ret
CheckBlackKing ENDP

    




getTime proc FAR

    ;cl minutes
    ;dh seconds
                             pusha
                             mov   ah,2ch
                             int   21h

  
                             cmp   dh,prevSecond

                             jnz   contGetTime
                             jmp   endGetTime
    contGetTime:             
                             mov   prevSecond,dh
                             cmp   cl,startMinute
                             jnz   notEqual
                             sub   dh,startSecond              ;in same minute as start just sub
                             mov   cl,0                        ;number of minutes that has passed is zero since they are equal
                             jmp   calcTime

    notEqual:                
                             cmp   dh,startSecond
                             jge   higher2
                             add   dh,60                       ; not same minute as start add (60-startsecnond)
                             jmp   calcSec
    higher2:                 
                             inc   cl
    calcSec:                 
                             sub   dh,startSecond

                             cmp   cl,startMinute
                             jg    higher
    ; if this minute is lower means the hour changed and will do some quick maths :)
                             add   cl,60
    higher:                  
                             sub   cl,startMinute              ;getting minutes passed exaple (50-45=5)
                             dec   cl


    calcTime:                                                  ;starts calculating time after correct min is in cl and second in dh
                             pusha
                             mov   al,60
                             mul   cl                          ;getting minutes in seconds

                             mov   dl,dh
                             mov   dh,0                        ;setting dl to zero to add dh to ah so we get total seconds passed
                             add   ax,dx                       ;time now is here (0->3600 seconds)
                            
                             mov   time,ax
                             popa
                             call  checkTime
                          
                             mov   x,29
                             mov   y,12
                             call  movecursor
                             mov   al,cl
                             mov   ah,0
                             mov   bl,10
                             div   bl
                             lea   di,min
                             add   al,'0'
                             add   ah,'0'
                             mov   [di],al
                             inc   di

                             mov   [di],ah
                             push  dx
                             mov   dx,offset min
                             mov   ah,9
                             int   21h
                             pop   dx


                             mov   al,dh
                             mov   ah,0
                             div   bl
                             lea   di,sec
                             add   al,'0'
                             add   ah,'0'
                             mov   [di],al
                             inc   di
                             mov   [di],ah
                             mov   dx,offset sec
                             mov   ah,9
                             int   21h


                                
    endGetTime:              
                             popa
                             ret
getTime endp
setTime proc FAR                                               ;sets game start time
                             pusha
                             mov   ah,2ch                      ;int to get time
                             int   21h

                             mov   startHour,ch
                             mov   startMinute,cl
                             mov   startSecond,dh
                                
                             popa
                             ret
setTime endp


    
moveWhitePlayer proc FAR
                             pusha
    ;  call  getTime
                             mov   al,x1
                             mov   ah,y1

                             mov   Column,al
                             mov   Row,ah
    
                             call  getBoardDiff                ;gets board base (bx) in diff
    ;*****time**************
                             mov   bl,storedPos1
                             
                             mov   al,2
                             mul   bl                          ;getting bx*2 because time is in words
                             mov   bx,ax                       ;bx now has the correct offset
    ;  mov   ax,timeBoard[bx]
                             mov   ax,time                     ;getting time
                             mov   dx,timeBoard[bx]
                             sub   ax,dx
                             cmp   ax,2                        ;if greater than 2 means 3 seconds has passed and he is allowed to move
                             
                             jg    contMoveWhite
                             jmp   moveWhiteEnd
    contMoveWhite:           

                             mov   bl,diff
                             mov   bh,0
    
                             mov   cl,player1Board[bx]         ;checks if this place is highlighted or not
                             cmp   cl,1
                             jz    moving
                             jmp   moveWhiteEnd                ; not highlighted so quit
    moving:                  
                             mov   moveTurn,1

                             
                             mov   al,2                        ;putting new time in the new cell
                             mov   bl,diff
                             mov   bh,0
                             mul   bl
                             mov   bx,ax
                             mov   ax,time
                             mov   timeBoard[bx],ax
    
                             mov   bl,storedPos1               ;moving the piece to storedPos
                             mov   al,board[bx]                ;taking piece in al
                            
                             cmp   al,16                       ;checking if it's king
                             jnz   contMovingWhite
                             push  ax
                             mov   al,x1
                             mov   kx1,al                      ;putting new kings coordinates
                             mov   ah,y1
                             mov   ky1,ah
                             pop   ax
    contMovingWhite:         
                             mov   board[bx],0                 ;clears old place
                             mov   bl,diff

                             mov   dl,board[bx]
                             mov   piece,dl
                             mov   board[bx],al                ;moves piece into new place
                             cmp   piece,00
                             jnz   dead
                             jmp   s
                             
    dead:                    
                             mov   dh,Row
                             mov   dl,Column
                             CALL  StatusBarWhite
                             mov   Row,dh
                             mov   Column,dl
    
    s:                       mov   piece,al                    ;drawing new cell and highlighting it
                             mov   Colour,highlight1
                             call  DrawCell
                             call  drawPiece                   ;drawing piece in new cell

                             mov   al,storedx1                 ;draws old piece cell
                             mov   ah,storedy1
                             mov   Column,al
                             mov   Row,ah
    
                             mov   bl,storedPos1
                             lea   si,player2Board
                             add   si,bx
                             call  checkEmptyCell
                             call  DrawCell


                             lea   di,player1Board             ;clearing the player's board
                             lea   si,player2Board
                             mov   bl,movmentHighlight2
                             mov   otherBoardColour,bl
                             call  clearBoardHighlight


            
                             lea   di,player2Board             ;clearing the player's board
                             lea   si,player1Board
                             mov   bl,movmentHighlight1
                             mov   otherBoardColour,bl
                             call  clearBoardHighlight

                             mov   al,storedx2
                             mov   ah,storedy2
                             mov   Column,al
                             mov   Row,ah
                             call  getPieceBoard
    moveWhiteEnd:            
                             call  checkTime
                             popa
                             ret
                             endp  moveWhitePlayer

moveBLackPlayer proc FAR
                             pusha
    ;  call  getTime
                             mov   al,x2
                             mov   ah,y2

                             mov   Column,al
                             mov   Row,ah
    
                             call  getBoardDiff                ;gets board base (bx) in diff

    ;*****time*********
                             mov   bl,storedPos2
                             
                             mov   al,2
                             mul   bl                          ;getting bx*2 because time is in words
                             mov   bx,ax                       ;bx now has the correct offset
    ;  mov   ax,timeBoard[bx]
                             mov   ax,time                     ;getting time
                             mov   dx,timeBoard[bx]
                             sub   ax,dx
                             cmp   ax,2                        ;if greater than 2 means 3 seconds has passed and he is allowed to move
                             
                             jg    contMoveBlack
                             jmp   moveBlackEnd
    contMoveBlack:           

                             mov   bl,diff
                             mov   bh,0
    
                             mov   cl,player2Board[bx]         ;checks if this place is highlighted or not
                             cmp   cl,1
                             jz    moving2
                             jmp   moveBlackEnd                ; not highlighted so quit
    moving2:                 
                             mov   moveTurn,1
                             
                             mov   al,2                        ;putting new time in the new cell
                             mov   bl,diff
                             mov   bh,0
                             mul   bl
                             mov   bx,ax
                             mov   ax,time
                             mov   timeBoard[bx],ax
    
                             mov   bl,storedPos2               ;moving the piece to storedPos
                             mov   al,board[bx]                ;taking piece in al

                             cmp   al,06                       ;checking if it's king
                             jnz   contMovingBLack
                             push  ax
                             mov   al,x2
                             mov   kx2,al                      ;putting new kings coordinates
                             mov   ah,y2
                             mov   ky2,ah
                             pop   ax
    contMovingBLack:         

                             mov   board[bx],0                 ;clears old place
                             mov   bl,diff
                             mov   dl,board[bx]
                             mov   piece,dl
                             mov   board[bx],al                ;moves piece into new place
                             cmp   piece,00
                             jnz   dead1
                             jmp   s1
                             
    dead1:                   
                             mov   dh,Row
                             mov   dl,Column
                             CALL  StatusBarBlack
                             mov   Row,dh
                             mov   Column,dl
    
    s1:                      mov   piece,al                    ;drawing new cell and highlighting it
                             mov   Colour,highlight2
                             call  DrawCell
                             call  drawPiece                   ;drawing piece in new cell

                             mov   al,storedx2                 ;draws old piece
                             mov   ah,storedy2
                             mov   Column,al
                             mov   Row,ah
    
                             mov   bl,storedPos2
                             lea   si,player1Board
                             add   si,bx
                             call  checkEmptyCell
                             call  DrawCell


                             lea   di,player2Board             ;clearing the player's board
                             lea   si,player1Board
                             mov   bl,movmentHighlight1
                             mov   otherBoardColour,bl
                             call  clearBoardHighlight


            
                             lea   di,player1Board             ;clearing the other player's board
                             lea   si,player2Board
                             mov   bl,movmentHighlight2
                             mov   otherBoardColour,bl
                             call  clearBoardHighlight

                             mov   al,storedx1
                             mov   ah,storedy1
                             mov   Column,al
                             mov   Row,ah
                             call  getPieceBoard
    moveBlackEnd:            
                             call  checkTime
                             popa
                             ret
                             endp  moveBlackPlayer




GetEnterQ PROC FAR
                             pusha

    ;Check Q
                             CMP   Al, 48
                             jz    contQ
                             Jmp   GetEnterQExit
    contQ:                   
                             cmp   playerColour,1
                             jz    contQ2
                             jmp   contEnter
    contQ2:                  
                             CALL  moveWhitePlayer
                             mov   al,moveTurn
                             cmp   al,0
                             jz    whiteMovments
                             jmp   whiteMoved

    whiteMovments:           
    ;clears board(debuging only)
                             lea   di,player1Board
                             lea   si,player2Board
                             mov   bl,movmentHighlight2
                             mov   otherBoardColour,bl
                             call  clearBoardHighlight
                            
                              


                      
                             MOV   AL, x1
                             MOV   AH, y1
                             MOV   storedx1,AL
                             MOV   storedy1,AH
                             MOV   Row,AH
                             MOV   Column,AL




                             CALL  getPieceBoard
                             mov   bl,diff
                             mov   storedPos1,bl
                             
                             jmp   contWhiteMovment
    blackMoved:              
                             mov   al,x1
                             mov   ah,y1
                             push  ax
                             mov   al,storedx1
                             mov   ah,storedy1
                             mov   x1,al
                             mov   y1,ah
    contWhiteMovment:        

                             MOV   dl,movmentHighlight1
                             MOV   CurrHighlight,dl
                             CALL  WhiteQueenMovment
                             CALL  WhiteknightMovment
                             CALL  WhitePawnMovment
                             CALL  WhiteRockMovment
                             CALL  WhiteBishopMovement
                             CALL  WhitekingMovment

                             cmp   moveTurn,1
                             jz    contWhiteMovment2
                             jmp   GetEnterQExit
    contWhiteMovment2:       
                             pop   ax
                             mov   x1,al
                             mov   y1,ah

                             JMP   GetEnterQExit

    contEnter:               
                             CALL  moveBlackPlayer
                             mov   al,moveTurn
                             cmp   al,0
                             jz    BlackMovments
                             jmp   blackMoved

    BlackMovments:           

                          
    ;clears player two board
                             lea   di,player2Board
                             lea   si,player1Board
                             mov   bl,movmentHighlight1
                             mov   otherBoardColour,bl
                             call  clearBoardHighlight
                    
    

                             MOV   AL, x2
                             MOV   AH, y2
                             MOV   storedx2,AL
                             MOV   storedy2,AH
                             MOV   Row,AH
                             MOV   Column,AL
                    

                             CALL  getPieceBoard

                             mov   bl,diff
                             mov   storedPos2,bl
                             jmp   contBlackMovment

                             
    whiteMoved:              
                             mov   al,x2
                             mov   ah,y2
                             push  ax
                             mov   al,storedx2
                             mov   ah,storedy2
                             mov   x2,al
                             mov   y2,ah
    contBlackMovment:        
                             MOV   dl,movmentHighlight2
                             MOV   CurrHighlight,dl
                             CALL  BlackQueenMovment
                             CALL  BlackknightMovment
                             CALL  BlackPawnMovment
                             CALL  BlackRockMovment
                             CALL  BlackBishopMovement
                             CALL  BlackKingMovment

                             cmp   moveTurn,1
                             jnz   GetEnterQExit
                             pop   ax
                             mov   x2,al
                             mov   y2,ah

    GetEnterQExit:           
                             mov   moveTurn,0
                             popa
                             RET
GetEnterQ ENDP


refrenceGame proc
                             pusha
                             mov   bx,63
                             mov   x1,4
                             mov   y1,7
                             mov   storedx1,4
                             mov   storedy1,7
                             mov   storedPos1,60
                             mov   x2,4
                             mov   y2,0
                             mov   storedx2,4
                             mov   storedy2,0
                             mov   storedPos2,4
                             mov   kx1,4
                             mov   ky1,7
                             mov   kx2,4
                             mov   ky2,0
                             mov   statusbarRow1,0
                             mov   statusbarColumn1,25
                             mov   statusbarRow2,13
                             mov   statusbarColumn2,25
    refLoop:                 
                             mov   al ,refrenceBoard[bx]
                             mov   board[bx],al

                             push  bx
                             mov   ax,0002
                             mul   bl
                             mov   bx,ax
                             mov   ax,-4
                             mov   timeBoard[bx],ax
                             pop   bx

                             mov   player1Board[bx],0
                             mov   player2Board[bx],0
                             dec   bx
                             cmp   bx,-1
                             jnz   refLoop
                             mov   chatx1,25
                             mov   chaty1,2
                             mov   chatx2,25
                             mov   chaty2,15
                             popa
                             ret
                             endp  refrenceGame


    ;checking if in previous square if player 1 is there
movePlayer2 proc FAR
                             pusha
  
    ;al is row , ah is column
                             mov   bl,coord1
                             mov   bh,0
                             mov   cl,board[bx]                ;taking the piece
                             mov   board[bx],0                 ;zeroing old place
                             mov   bl,coord2
                             mov   board[bx],cl                ;piece is now in it's new place
                             mov   piece,cl

                             mov   al,coord1
                             mov   ah,0
                             mov   bl,8
                             div   bl
                             mov   Column,ah
                             mov   Row,al
                             call  GetColour
                             call  DrawCell

                             mov   al,coord2
                             mov   ah,0
                             mov   bl,8
                             div   bl
                             mov   Column,ah
                             mov   Row,al
                             call  GetColour
                             call  DrawCell
                             call  drawPiece





                             popa
                             ret
                             endp  movePlayer2


scrollChat1 proc FAR
                             pusha

                             mov   x,29
                             mov   y,1

    scrool1:                 
                             call  movecursor
                             mov   ah,2
                             mov   dl,' '
                             int   21h
                             inc   x
                             cmp   x,40
                             jnz   scrool1
                             mov   x,25
                             inc   y
                             cmp   y,12
                             jnz   scrool1

                             mov   x,25
                             mov   y,15
                             mov   chatx1,29
                             mov   chaty1,1
                             call  checkWhiteKing

                             popa
                             ret
                             endp  scrollChat1

scrollChat2 proc FAR
                             pusha

                             mov   x,29
                             mov   y,14

    scrool2:                 
                             call  movecursor
                             mov   ah,2
                             mov   dl,' '
                             int   21h
                             inc   x
                             cmp   x,40
                             jnz   scrool2
                             mov   x,25
                             inc   y
                             cmp   y,24
                             jnz   scrool2

                             mov   chatx2,29
                             mov   chaty2,14


         

                             call  checkBlackKing

                             popa
                             ret
                             endp  scrollChat2

     RecieveScroll PROC FAR
 pusha
                mov   ax,0601h
                mov   bh,00
                mov   cx,0f19H
                mov   dx,172eH
                int   10h

                MOV   chatx2, 25
                MOV   chaty2, 23
                MOV   AL,chatx1
                MOV   AH,chaty1

                popa
                ret
                  
RecieveScroll ENDP
SendScroll PROC FAR
                pusha
                mov   ax,0601h
                mov   bh,00
                mov   cx,0219H
                mov   dx,0a2eH
                int   10h

                MOV   chatx1, 25
                MOV   chaty1, 10
                MOV   AL,chatx1
                MOV   AH,chaty1

                popa
                ret
               
SendScroll ENDP
    

printChat PROC  FAR
                             pusha
MOV   SENDVALUE,AL
                CMP   SENDVALUE,8
                JZ    BACKSPACE
                MOV   AH,0Ch
                INT   21h

                CMP   SENDVALUE,13
                JZ    ENTERLINE
                JMP   FSS

  ENTERLINE:    INC   chaty1
                MOV   chatx1,25
                MOV   AL,chatx1
                MOV   AH,chaty1
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
                CMP   chatx1,25
                JNZ   CANBS
                CMP   chaty1,2
                JNZ   CANBS
                JMP   kkk

  CANBS:        CMP   chatx1,25
                JNZ   CANBS1
                MOV   chatx1,39
                DEC   chaty1
                MOV   BH,chatx1
                MOV   BL,chaty1
                MOV   x,BH
                MOV   y,BL
                CALL  movecursor
                mov   ah,2
                mov   dl,' '
                int   21h
                MOV   BH,chatx1
                MOV   BL,chaty1
                MOV   x,BH
                MOV   y,BL
                CALL  movecursor
                JMP   kkk

  CANBS1:       DEC   chatx1
                MOV   BH,chatx1
                MOV   BL,chaty1
                MOV   x,BH
                MOV   y,BL
                CALL  movecursor
                mov   ah,2
                mov   dl,' '
                int   21h
                MOV   BH,chatx1
                MOV   BL,chaty1
                MOV   x,BH
                MOV   y,BL
                CALL  movecursor
                jmp   kkk

  xxs:          MOV   AL,chatx1
                MOV   AH,chaty1
                MOV   x,AL
                MOV   y,AH
                CALL  movecursor
                mov   ah,2
                mov   dl,SENDVALUE
                int   21h
                cmp   chatx1,39
                jz    kline
                INC   chatx1
                JMP   kkk

  kline:        mov   chatx1,25
                inc   chaty1
             

  kkk:          

                cmp   chaty1,11
                JB    LL
                ; call  scrollChat1
                 call  SendScroll

  LL:           
  call checkBlackKing
                             popa
                             ret


                             endp  printChat

printChatYOU PROC  FAR
                             pusha
MOV   SENDVALUE,AL
                CMP   SENDVALUE,8
                JZ    BACKSPACE2
                MOV   AH,0Ch
                INT   21h

                CMP   SENDVALUE,13
                JZ    ENTERLINE2
                JMP   FSS2

  ENTERLINE2:    INC   chaty2
                MOV   chatx2,25
                MOV   AL,chatx2
                MOV   AH,chaty2
                MOV   x,AL
                MOV   y,AH
                CALL  movecursor
                jmp   kkk2

  FSS2:          CMP   SENDVALUE,8
                JZ    BACKSPACE2
                JMP   xxs2

  BACKSPACE2:    
   
                CMP   chatx2,25
                JNZ   CANBS2
                CMP   chaty2,15
                JNZ   CANBS2
                JMP   kkk2

  CANBS2:        CMP   chatx2,25
                JNZ   CANBS12
                MOV   chatx2,39
                DEC   chaty2
                MOV   BH,chatx2
                MOV   BL,chaty2
                MOV   x,BH
                MOV   y,BL
                CALL  movecursor
                mov   ah,2
                mov   dl,' '
                int   21h
                MOV   BH,chatx2
                MOV   BL,chaty2
                MOV   x,BH
                MOV   y,BL
                CALL  movecursor
                JMP   kkk2

  CANBS12:       DEC   chatx2
                MOV   BH,chatx2
                MOV   BL,chaty2
                MOV   x,BH
                MOV   y,BL
                CALL  movecursor
                mov   ah,2
                mov   dl,' '
                int   21h
                MOV   BH,chatx2
                MOV   BL,chaty2
                MOV   x,BH
                MOV   y,BL
                CALL  movecursor
                jmp   kkk2

  xxs2:          MOV   AL,chatx2
                MOV   AH,chaty2
                MOV   x,AL
                MOV   y,AH
                CALL  movecursor
                mov   ah,2
                mov   dl,SENDVALUE
                int   21h
                cmp   chatx2,39
                jz    kline2
                INC   chatx2
                JMP   kkk2

  kline2:        mov   chatx2,25
                inc   chaty2


  kkk2:         

                cmp   chaty2,24
                JB    LL2
                ; call  scrollChat2
                call RecieveScroll

  LL2:
  call checkWhiteKing           
                             popa
                             ret


                             endp  printChatYOU





MAIN PROC FAR
                             MOV   AX,@DATA
                             MOV   DS,AX


                             call  getName
                             
                             call  startMenu

         
                             

                             mov   sent,0
                             mov   recvied,0
                             mov   sentGame,0
                             mov   recviedGame,0
                             call  setTime
                             call  drawMainBoard
                             call  DrawStatusLine
                             call  refrenceGame
                             


                             jmp   mainLoop
    startAgain:              
                             call  refrenceGame
                             call  startMenu
                             call  setTime


                             mov   sent,0
                             mov   recvied,0
                             mov   sentGame,0
                             mov   recviedGame,0

   
    mainLoop:                
                             call  getTime

                             cmp   win,0
                             jz    recieving


    ;go to text mode
                             MOV   AH,0
                             MOV   AL,03h
                             INT   10H



    ;move cursor to the middle of screen
                             mov   ah,2
                             mov   dx,0B11h
                             int   10h


    ;print who wins
                             CMP   win,1
                             JZ    BlackWin

                             mov   ah, 9
                             mov   dx, offset WhiteWinMSG
                             int   21h
                             jmp   MainExit


    BlackWin:                mov   ah, 9
                             mov   dx, offset BlackWinMSG
                             int   21h
                             jmp   MainExit



    recieving:               mov   dx , 3FDH                   ; Line Status Register
                             in    al , dx
                             AND   al , 1
                             JZ    contgame
                             mov   dx , 03F8H
                             in    al , dx
                             CMP   Al,62
                             JZ    STARTTEMP
                             cmp   al,72                       ;up
                             jz    STARTTEMP2
                             cmp   al,75                       ;left
                             jz    STARTTEMP2
                             cmp   al,77                       ;right
                             jz    STARTTEMP2
                             cmp   al,80                       ;downn
                             jz    STARTTEMP2
                             cmp   al,48                       ;downn
                             jz    STARTTEMP2

                             cmp   al,8
                             jz    contCheckCHatyou2
                             cmp   al,13
                             jz    contCheckCHatyou2
                             cmp   al,32
                             jz    contCheckCHatyou2

                             cmp   al,96
                             jg    contCheckCHatyou
                             jmp   contgame
    contCheckCHatyou:        
                             cmp   al,123
                             jl    contCheckCHatyou2
                             jmp   contgame
    contCheckCHatyou2:       
                             CALL  printChatYOU
                             jmp   contgame
    STARTTEMP:               JMP   MainExit2

    STARTTEMP2:              
                             push  ax
                             mov   ah,al
                             mov   al,playerColour2
                             mov   playerColour,al
                             pop   bx
                             push  ax
                             mov   ax,bx
                             CALL  PlayerMovment
                             CALL  GetEnterQ
                             CALL  checkWhiteKing
                             CALL  checkBlackKing
                             pop   ax
                             xor   al,1
                             mov   playerColour,al



    contgame:                                                  ;sending / taking user's normal input
                             mov   ah,01
                             int   16h
                             jz    poi
                             push  ax
                             mov   dx , 3FDH                   ; Line Status Register
                             In    al , dx                     ;Read Line Status
                             AND   al , 00100000b
                             JnZ   contgame2
                             pop   ax
    poi:                     jmp   mainLoop
    contgame2:               
                             pop   ax


                             cmp   ah,72                       ;up
                             jz    scanConverge
                             cmp   ah,62                       ;up
                             jz    scanConverge
                             cmp   ah,75                       ;left
                             jz    scanConverge
                             cmp   ah,77                       ;right
                             jz    scanConverge
                             cmp   ah,80                       ;downn
                             jz    scanConverge
                             jmp   sendlabel
    scanConverge:            
                             mov   al,ah
    sendlabel:               
                             mov   dx , 3F8H                   ; Transmit data register

                             out   dx , al
                    
                             push  ax
                            
                             pop   ax
                             CMP   AH,62                       ;f4 condition
                             JZ    STARTTEMP
                             


                             cmp   al,72                       ;up
                             jz    moveLabel
                             cmp   al,75                       ;left
                             jz    moveLabel
                             cmp   al,77                       ;right
                             jz    moveLabel
                             cmp   al,80                       ;downn
                             jz    moveLabel
                             cmp   al,48                       ;downn
                             jz    moveLabel


                             cmp   al,8
                             jz    contCheckCHat2
                             cmp   al,13
                             jz    contCheckCHat2
                             cmp   al,32
                             jz    contCheckCHat2

                             cmp   al,96
                             jg    contCheckCHat
                             jmp   goback
    contCheckCHat:           
                             cmp   al,123
                             jl    contCheckCHat2

                             goback:
                             MOV   AH,0Ch
                             INT   21h

                             jmp   mainLoop
    contCheckCHat2:          
                             CALL  printChat
                             jmp   mainLoop
                             


                             

                               
    ;  jmp mainLoop



    ;clear buffer
    moveLabel:               
                             CALL  PlayerMovment
                             CALL  GetEnterQ
                             CALL  checkWhiteKing
                             CALL  checkBlackKing
                             
    CheckEnterExit:          MOV   AH,0Ch
                             INT   21h

                             jmp   mainLoop

    MainExit2:               
                             CALL  clearscreen

    MainExit:                
    ;move cursor to the middle of screen
                             mov   ah,2
                             mov   dx,0E19h
                             int   10h

                             mov   ah, 9
                             mov   dx,offset presskey
                             int   21h

                             mov   ah,0                        ;wait for key press
                             int   16h
                             call  clearscreen
                             mov   win,0

                             mov   sent,0
                             mov   recvied,0
                             mov   sentGame,0
                             mov   recviedGame,0
                             JMP   startAgain
MAIN ENDP
END MAIN
