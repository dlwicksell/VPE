XVEMREP ;DJB,VRR**EDIT - Web,Html,Parse Rtn/Global,RETURN ; 1/6/01 8:38am
 ;;13.0;VICTORY PROG ENVIRONMENT;;Feb 29, 2016
 ;
WEB ;Web Mode
 I FLAGMODE["WEB" D WEB^XVEMRER Q
 S $P(FLAGMODE,"^",2)="WEB" D MODEON^XVEMRU("WEB")
 Q
 ;
HTML ;HTML Code insertion
 I FLAGMODE["HTML" D HTML^XVEMRER Q
 S $P(FLAGMODE,"^",3)="HTML" D MODEON^XVEMRU("HTML")
 Q
 ;===================================================================
PARSE ;Run rtn name from code at cursor position
 NEW FLAG,I,LINE,RTN,TAG,TMP
 ;
 S LINE=$G(^TMP("XVV","IR"_VRRS,$J,YND))
 ;
 ;Find TAG^RTN
 I LINE[$C(30) D  ;
 . S TAG=$E(LINE,(XCUR-7),(XCUR+1)) ;Go left for TAG
 . S RTN=$E(LINE,XCUR+3,XCUR+10) ;..Go right for LINE
 E  D  ;
 . S TAG=$E(LINE,10,XCUR)
 . I $L(TAG)>8 S TAG=$E(TAG,$L(TAG)-7,$L(TAG))
 . E  D
 . . S TMP=$G(^TMP("XVV","IR"_VRRS,$J,YND-1))
 . . S TAG=$E(TMP,$L(TMP)-(8-$L(TAG)+1),$L(TMP))_TAG
 . S RTN=$E(LINE,XCUR+2,XCUR+9)
 ;
 ;Find starting point of TAG
 F I=$L(TAG):-1:1 I $E(TAG,I)'?1AN,$E(TAG,I)'?1"%" D  Q
 . S TAG=$E(TAG,(I+1),$L(TAG))
 ;
 ;If rtn name has scrolled to a 2nd line
 I $L(RTN)'>7 D  ;
 . S TMP=$G(^TMP("XVV","IR"_VRRS,$J,(YND+1)))
 . Q:TMP[$C(30)  Q:TMP=" <> <> <>"
 . S RTN=RTN_$E(TMP,10,9+8-$L(RTN))
 ;
 ;Save RTN & TAG before clearing symbol table.
 S ^TMP("XVV",$J)=RTN_"^"_TAG
 D SYMTAB^XVEMKST("C","VRR",VRRS) ;Save symbol table
 ;
 ;FLAG("<ESC>R")=If user hits <ESC>R to branch to rtn, and the rtn is
 ;               locked, clear screen before displaying msg.
 S FLAG("<ESC>R")=1
 ;
 S RTN=$$GETRTN()
 S TAG=$P(^TMP("XVV",$J),"^",2)
 I RTN'=0 D PARAM^XVEMR(RTN,TAG)
 D SYMTAB^XVEMKST("R","VRR",VRRS) ;Restore symbol table
 KILL ^TMP("XVV",$J)
 Q
 ;
GETRTN() ;Parse routine name
 NEW CODE,I,RTN
 I VRRS>3 W $C(7) Q 0
 S CODE=$P(^TMP("XVV",$J),"^",1)
 S RTN=$E(CODE,1)
 I RTN'="%",RTN'?1A W $C(7) Q 0
 F I=2:1:8 Q:$E(CODE,I)'?1AN  S RTN=RTN_$E(CODE,I)
 I '$$EXIST^XVEMKU(RTN) W $C(7) Q 0
 Q RTN
 ;===================================================================
GLB ;Select global for viewing by hitting <ESCG>
 NEW DIFF,TMP,TMP1,ZX,ZY,ZZ
 I $G(FLAGGLB)']"" D  S KEY="S" Q
 . S TMP=$G(^TMP("XVV","IR"_VRRS,$J,YND))
 . I TMP[$C(30) S TMP=XCUR+2_"^"_$E(TMP,XCUR+2,XCUR+32)
 . E  S TMP=XCUR+1_"^"_$E(TMP,XCUR+1,XCUR+31)
 . S FLAGGLB=$P(TMP,"^",1)_"^"_YND_"^"_$P(TMP,"^",2,999)
 . S TMP=$P(FLAGGLB,"^",3,999)  Q:$L(TMP)>29
 . S TMP1=$G(^(YND+1))  Q:TMP1[$C(30)  Q:TMP1=" <> <> <>"
 . S FLAGGLB=FLAGGLB_$E(TMP1,10,10+30-$L(TMP))
 ;
 S ZX=$P(FLAGGLB,"^",1),ZY=$P(FLAGGLB,"^",2),ZZ=$P(FLAGGLB,"^",3,999)
 S DIFF=$S($G(^TMP("XVV","IR"_VRRS,$J,YND))[$C(30):XCUR+2,1:XCUR+1)
 I (YND-ZY)>1 KILL FLAGGLB Q  ;Moved cursor too far
 I (ZY>YND) KILL FLAGGLB Q  ;Moved cursor up
 I YND>ZY S DIFF=ZX+(XVV("IOM")-ZX)+DIFF-10 I ZX>DIFF KILL FLAGGLB Q
 S DIFF=DIFF-ZX+1,FLAGGLB=$E(ZZ,1,DIFF)
 S ^TMP("XVV",$J)=FLAGGLB KILL FLAGGLB
 D ENDSCR^XVEMKT2
 D SYMTAB^XVEMKST("C","VRR",VRRS) ;Save symbol table
 D PARAM^XVEMG(^TMP("XVV",$J))
 KILL ^TMP("XVV",$J)
 D SYMTAB^XVEMKST("R","VRR",VRRS) ;Restore symbol table
 D REDRAW1^XVEMRU
 Q
 ;===================================================================
RETURN ;Process <RET> key
 ;If new rtn, open new line regardless of parameter setting.
 I $G(^TMP("XVV","IR"_VRRS,$J,1))=" <> <> <>" D INSERT^XVEMRI(2) Q
 NEW MD,X,Y
 S MD="",FLAGSAVE=1
 S:$G(XVV("ID"))>0 MD=$G(^XVEMS("E","PARAM",XVV("ID"),"RETURN"))
 I MD'=2 D INSERT^XVEMRI(2) Q  ;Open line below
 S X=$G(^TMP("XVV","IR"_VRRS,$J,YND))
 I X=" <> <> <>"!(X']"") W $C(7) Q
 ;--> If cursor is at beginning of line, open line above
 I X[$C(30),XCUR'>($F(X,$C(30))-2) D INSERT^XVEMRI(1) Q
 ;--> If cursor is at end of line, open line below
 S Y=$G(^TMP("XVV","IR"_VRRS,$J,YND+1))
 I Y[$C(30)!(Y=" <> <> <>"),XCUR>($L(X)-$S(X[$C(30):2,1:1)) D INSERT^XVEMRI(2) Q
 ;--> Break line
 D BREAK^XVEMREJ
 D REDRAW^XVEMRU(YND)
 Q
